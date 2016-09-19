From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcachefs: Encryption (Posting for review)
Date: Sun, 18 Sep 2016 17:04:51 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609181610460.5413@mail.ewheeler.net>
References: <20160902044145.mkk6eipej6kbfhhi@kmo-pixel>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1284917978-1474243491=:5413"
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:48381 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755407AbcISAEx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Sep 2016 20:04:53 -0400
In-Reply-To: <20160902044145.mkk6eipej6kbfhhi@kmo-pixel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1284917978-1474243491=:5413
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 1 Sep 2016, Kent Overstreet wrote:

> Encryption in bcachefs is done and working and I just finished documenting the
> design - so now, it needs more eyeballs and vetting before letting users play
> with it.
> 
> ### Algorithms
> 
> By virtue of working within a copy on write filesystem with provisions for ZFS
> style checksums (that is, checksums with the pointers, not the data), we’re
> able to use a modern AEAD style construction. We use ChaCha20 and Poly1305. We
> use the cyphers directly instead of using the kernel AEAD library (and thus
> means there's a bit more in the design that needs auditing).

A few thoughts:

Great work implementing your own monotnoically-increasing nonce in 
bcachefs.  You have implemented your own crypto stack, I'm sure lots of 
time went into that.  Stream ciphers are great, but not always seekable 
(eg: output-feedback mode, OFM).  Of course if you plan to validate the 
MAC for every read, then seekable might not matter---but you will need to 
decrypt up to the offset you want even after MAC validation which adds 
overhead.

Since you have written a solid nonce generator, supporting the existing 
kernel library for block ciphers in counter-mode (CTR) is probably easy 
and would aide the validation of your protocol; indeed, it would 
future-proof bcachefs against maintaining new ciphers if the user can 
specify the kernel crypto library's block- or streamping- cipher.

For counter mode, shift the nonce by as many bits as the extent size 
divided by the cipher-block size.  For 64k extents and AES-128, you would 
shift the nonce like so:
	nonce <<= ilog2( 65536 / ilog2(128) )  

This example uses 12 nonce bits leaving 2^84 extent generations before 
wrapping.  (Of course you'll need to store the nonce in your extent 
metadata.)

You then have a counter for each 16-bytes of AES in the bottom bits of 
the extent nonce.  Counter mode is trivial to implement:
	ciphertext[   0] = E_k(nonce+   0) XOR plaintext[0]
	[...]
	ciphertext[4095] = E_k(nonce+4095) XOR plaintext[4095]

This gives you cipher-block-independent parallelism, seekability, and 
flexibility using existing and future block ciphers.  Counter mode is well 
studied, I don't think anyone will argue against that if your nonces are 
well founded. 

[... more below ]


> The current design uses the same key for both ChaCha20 and Poly1305, but my
> recent rereading of the Poly1305-AES paper seems to imply that the Poly1305 key
> shouldn't be used for anything else. Guidance from actual cryptographers would
> be appreciated here; the ChaCha20/Poly1305 AEAD RFC appears to be silent on the
> matter.
> 
> Note that ChaCha20 is a stream cypher. This means that it’s critical that we use
> a cryptographic MAC (which would be highly desirable anyways), and also avoiding
> nonce reuse is critical. Getting nonces right is where most of the trickiness is
> involved in bcachefs’s encryption.
> 
> The current algorithm choices are not hard coded. Bcachefs already has
> selectable checksum types, and every individual data and metadata write has a
> field that describes the checksum algorithm that was used. On disk, encrypted
> data is represented as a new checksum type - so we now have [none, crc32c,
> crc64, chacha20/poly1305] as possible methods for data to be
> checksummed/encrypted. If in the future we add new encryption algorithms, users
> will be able to switch to the new algorithm on existing encrypted filesystems;
> new data will be written with the new algorithm and old data will be read with
> the old algorithm until it is rewritten.
> 
> ### Key derivation, master key
> 
> Userspace tooling takes the user's passphrase and derives an encryption key with
> scrypt. This key is made available to the kernel (via the Linux kernel's keyring
> service) prior to mounting the filesystem.
> 
> On filesystem mount, the userspace provided key is used to decrypt the master
> key, which is stored in the superblock - also with ChaCha20. The master key is
> encrypted with an 8 byte header, so that we can tell if the correct key was
> supplied.
> 
> ### Metadata
> 
> Except for the superblock, no metadata in bcache/bcachefs is updated in place -
> everything is more or less log structured. Only the superblock is stored
> unencrypted; other metadata is stored with an unencrypted header and encrypted
> contents.
> 
> The superblock contains:
>  * Label and UUIDs identifying the filesystem
>  * A list of component devices (for multi-device filesystems), and information
>    on their size, geometry, status (active/failed), last used timestamp
>  * Filesystem options
>  * The location of the journal
> 
> For the rest of the metadata, the unencrypted portion contains:
> 
>  * 128 bit checksum/MAC field
>  * Magic number - identifies a given structure as btree/journal/allocation
>    information, for that filesystem
>  * Version number (of on disk format), flags (including checksum/encryption
>    type).
>  * Sequence numbers: journal entries have an ascending 64 bit sequence number,
>    btree node entries have a random 64 bit sequence number identifying them as
>    belonging to that node. Btree nodes also have a field containing the sequence
>    number of the most recent journal entry they contain updates from; this is
>    stored unencrypted so it can be used as part of the nonce.
>  * Size of the btree node entry/journal entry, in u64s
> 
> Btree node layout information is encrypted; an attacker could tell that a given
> location on disk was a btree node, but the part of the header that indicates
> what range of the keyspace, or which btree ID (extents/dirents/xattrs/etc.), or
> which level of the btree is all encrypted.
> 
> #### Metadata nonces
> 
>  * Journal entries use their sequence number - which is unique for a given
>    filesystem. When metadata is being replicated and we're doing multiple
>    journal writes with the same sequence number - and thus nonce - we really are
>    writing the same data (we only checksum once, not once per write).
> 
>  * Btree nodes concatenate a few things for the nonce:
>    - A 64 bit random integer, which is generated per btree node (but btree nodes
>      are log structured, so entries within a given btree node share the same
>      integer).
>    - A journal sequence number. For btree node writes done at around the same
>      point in time, this field can be identical in unrelated btree node writes -
>      but only for btree nodes writes done relatively close in time, so the
>      journal sequence number plus the previous random integer should be more
>      than sufficient entropy.
>    - And lastly the offset within the btree node, so that btree node entries
>      sharing the same random integer are guaranteed a different nonce.
> 
>  * Allocation information (struct prio_set):
>    bcache/bcachefs doesn't have allocation information persisted like other
>    filesystems, but this is our closest equivalent - this structure mainly
>    stores generation numbers that correspond to extent pointers.
> 
>    Allocation information uses a dedicated randomly generated 96 bit nonce
>    field.
> 
> ### Data
> 
> Data writes have no unencrypted header: checksums/MACs, nonces, etc. are stored
> with the pointers, ZFS style.
> 
> Bcache/bcachefs is extent based, not block based: pointers point to variable
> sized chunks of data, and we store one checksum/MAC per extent, not per block: a
> checksum or MAC might cover up to 64k (extents that aren't checksummed or
> compressed may be larger). Nonces are thus also per extent, not per block.
> 
> Currently, the Poly1305 MAC is truncated to 64 bits - due to a desire not to
> inflate our metadata any more than necessary. Guidance from cryptographers is
> requested as to whether this is a reasonable option; do note that the MAC is not
> stored with the data, but is itself stored encrypted elsewhere in the btree. 

Encrypted or not, MACs are already only as strong as sqrt(2^n) because of 
birthday paradox collisions.  Truncating to 64 bits guarantees a MAC 
collision every 2^32 generations which is too weak in my opinion.  Lost 
space or no, it is definitely better to keep the MAC the same size as the 
MACing function (or hash if HMAC).

Another note on MACs:  Using Poly1305 sounds great, but what if it is 
found to be weakened or broken or deprecated in the future? 

IMO, it would best to support MACs as HMACs and allow the user to specify 
the hash function using the existing kernel crypto library.  HMAC 
construction is as follows (|| means append):

	HMAC_{HASH,key}(data) = HASH(HASH(key) || HASH(data))


Of course you are welcome to support all of the above and let the user 
decide on the MAC function (poly1305 vs HMAC_{HASH,key}) and crypto 
function (counter-mode+block-cipher, streaming ciphers including chacha*).

It is appealing to have super-fast chacha20+poly1305---and equally so to 
have the flexibility and breadth of the existing crypto suite using well 
tested crypto constructs like counter-mode and HMAC.


--
Eric Wheeler

> We do already have different fields for storing 4 byte checksums and 8 
> byte checksums; it will be a trivial matter to add a field allowing 16 
> byte checksums to be stored, and we will add that anyways - so this 
> isn't a pressing design issue, this is just a matter of what the 
> defaults should be and what we should tell users.
> 
> #### Extent nonces
> 
> We don't wish to simply add a random 96 bit nonce to every extent - that would
> inflate our metadata size by a very significant amount. Instead, keys (of which
> extents are a subset) have a 96 bit version number field; when encryption is
> enabled, we ensure that version numbers are enabled and every new extent gets a
> new, unique version number.
> 
> However, extents may be partially overwritten or split, and then to defragment
> we may have to rewrite those partially overwritten extents elsewhere. We cannot
> simply pick a new version number when we rewrite an extent - that would break
> semantics other uses of version numbers expect.
> 
> When we rewrite an extent, we only write the currently live portions of the
> extent - we don't rewrite the parts that were overwritten. We can't write it out
> with the same nonce as the original extent.
> 
> If we concatenated the version number with the offset within the file, and the
> extent's current size - that would work, except that it would break fcollapse(),
> which moves extents to a new position within a file. We are forced to add some
> additional state to extents.
> 
> We could add a small counter that is incremented every time the size of an
> extent is reduced (and the data it points to changes); we can easily bound the
> size of the counter we need by the maximum size of a checksummed extent. But
> this approach fails when extents are split.
> 
> What can work is if we add a field for "offset from the start of the original
> extent to the start of the current extent" - updating that field whenever we
> trim the front of an extent.
> 
> If we have that, then we could simply skip ahead in the keystream to where the
> currently live data lived in the original extent - there's no problem with nonce
> reuse if you're encrypting exactly the same data. Except - that fails with
> compression, since if we take an extent, drop the first 4k, and compress it,
> that won't give the same data as if we compress it and then drop the first 4k of
> the compressed data.
> 
> The approach almost works though, if we take that offset and use it as part of
> our nonce: what we want to do is construct a function that will output the same
> nonce iff two extents (fragments of the same original extent) really are the
> same data.
> 
> Offset into the original extent works in the absence of compression - two
> fragments with the same offset but different sizes will be equal in their common
> prefix, ignoring compression. We can handle compression if we also include both
> the current size, and the current compression function - offset + current size
> uniquely determines the uncompressed data, so, offset + current size +
> compression function will uniquely determine the compressed output.
> 
> #### Nonce reuse on startup
> 
> After recovery, we must ensure we don't reuse existing version numbers - we must
> ensure that newly allocated version numbers are strictly greater than any
> version number that has every been used before.
> 
> The problem here is that we use the version number to write the data before
> adding the extent with that version number to the btree: after unclean shutdown,
> there will have been version numbers used to write data for which we have no
> record in the btree.
> 
> The rigorous solution to this is to add a field (likely to the journal header)
> that indicates version numbers smaller than that field may have been used.
> However, we don't do that yet - it's not completely trivial since it'll add
> another potential dependency in the IO path that needs some analysis.
> 
> The current solution implemented by the code is to scan every existing version
> number (as part of an existing pass), and set the next version number to
> allocate to be 64k greater than the highest existing version number that was
> found.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-1284917978-1474243491=:5413--
