From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: bcachefs: Encryption (Posting for review)
Date: Thu, 1 Sep 2016 20:41:45 -0800
Message-ID: <20160902044145.mkk6eipej6kbfhhi@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-bcache@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Encryption in bcachefs is done and working and I just finished documenting the
design - so now, it needs more eyeballs and vetting before letting users play
with it.

I'd appreciate help circulating this around to people who'd be qualified to
review it, too.

Also, bcachefs development is still moving along but it still needs funding: if
you're a fan of bcache or fancypants new filesystems, please chip in -
https://www.patreon.com/bcachefs
https://bcache.evilpiepirate.org/Bcachefs/

-------------

The master copy of this document is at:
https://bcache.evilpiepirate.org/Encryption/

# bcache/bcachefs encryption design:

This document is intended for review by cryptographers and other experience
implementers of cryptography code, before the design is frozen. Everything
described in this document has been implemented and tested.

The code may be found at
[[https://evilpiepirate.org/git/linux-bcache.git/log/?h=bcache-encryption]]

Feedback and comments should be sent to Kent Overstreet,
kent.overstreet@gmail.com.

## Intro:

Bcachefs provides whole-filesystem encryption, using ChaCha20/Poly1305.
Encryption may be enabled when creating a filesystem, or encryption may be
enabled on an existing filesystem (TODO: implement interface for enabling
encryption on an existing filesystem - kernel code exists).

Example:

    $ bcache format --encrypted /dev/sda

(Enter passphrase when prompted)

    $ bcache unlock /dev/sda

(Enter passphrase again)

Then mount as normal:

    $ mount /dev/sda /mnt

## Goals:

Bcachefs encryption is meant to be a clean slate design that prioritizes
security and robustness, and is meant to defend against a wider variety of
yadversarial models than is typical in existing filesystem level or block level
encryption.

## Filesystem vs. directory encryption

We do not currently offer per directory encryption; instead, we take an "encrypt
everything" approach.

Rationale:

With per directory encryption, preventing metadata from leaking is highly
problematic.  For example, file sizes - file sizes are required for fsck, so
they would have to be stored unencrypted - or failing that some complicated way
of deferring fsck for that part of the filesystem until the key has been
provided. There would be additional complications around filenames, xattrs,
extents (and inline extents), etc. - not necessarily insurmountable, but they
would definitely lead to a more complicated, more fragile design.

With whole filesystem encryption, it’s much easier to say what is and isn’t
encrypted, we can encrypt at the granularity of an entire metadata write (a
journal entry, a btree node) and it's much easier to show that the contents -
everything after the header for that particular metadata write - will not leak.

### Algorithms

By virtue of working within a copy on write filesystem with provisions for ZFS
style checksums (that is, checksums with the pointers, not the data), we’re
able to use a modern AEAD style construction. We use ChaCha20 and Poly1305. We
use the cyphers directly instead of using the kernel AEAD library (and thus
means there's a bit more in the design that needs auditing).

The current design uses the same key for both ChaCha20 and Poly1305, but my
recent rereading of the Poly1305-AES paper seems to imply that the Poly1305 key
shouldn't be used for anything else. Guidance from actual cryptographers would
be appreciated here; the ChaCha20/Poly1305 AEAD RFC appears to be silent on the
matter.

Note that ChaCha20 is a stream cypher. This means that it’s critical that we use
a cryptographic MAC (which would be highly desirable anyways), and also avoiding
nonce reuse is critical. Getting nonces right is where most of the trickiness is
involved in bcachefs’s encryption.

The current algorithm choices are not hard coded. Bcachefs already has
selectable checksum types, and every individual data and metadata write has a
field that describes the checksum algorithm that was used. On disk, encrypted
data is represented as a new checksum type - so we now have [none, crc32c,
crc64, chacha20/poly1305] as possible methods for data to be
checksummed/encrypted. If in the future we add new encryption algorithms, users
will be able to switch to the new algorithm on existing encrypted filesystems;
new data will be written with the new algorithm and old data will be read with
the old algorithm until it is rewritten.

### Key derivation, master key

Userspace tooling takes the user's passphrase and derives an encryption key with
scrypt. This key is made available to the kernel (via the Linux kernel's keyring
service) prior to mounting the filesystem.

On filesystem mount, the userspace provided key is used to decrypt the master
key, which is stored in the superblock - also with ChaCha20. The master key is
encrypted with an 8 byte header, so that we can tell if the correct key was
supplied.

### Metadata

Except for the superblock, no metadata in bcache/bcachefs is updated in place -
everything is more or less log structured. Only the superblock is stored
unencrypted; other metadata is stored with an unencrypted header and encrypted
contents.

The superblock contains:
 * Label and UUIDs identifying the filesystem
 * A list of component devices (for multi-device filesystems), and information
   on their size, geometry, status (active/failed), last used timestamp
 * Filesystem options
 * The location of the journal

For the rest of the metadata, the unencrypted portion contains:

 * 128 bit checksum/MAC field
 * Magic number - identifies a given structure as btree/journal/allocation
   information, for that filesystem
 * Version number (of on disk format), flags (including checksum/encryption
   type).
 * Sequence numbers: journal entries have an ascending 64 bit sequence number,
   btree node entries have a random 64 bit sequence number identifying them as
   belonging to that node. Btree nodes also have a field containing the sequence
   number of the most recent journal entry they contain updates from; this is
   stored unencrypted so it can be used as part of the nonce.
 * Size of the btree node entry/journal entry, in u64s

Btree node layout information is encrypted; an attacker could tell that a given
location on disk was a btree node, but the part of the header that indicates
what range of the keyspace, or which btree ID (extents/dirents/xattrs/etc.), or
which level of the btree is all encrypted.

#### Metadata nonces

 * Journal entries use their sequence number - which is unique for a given
   filesystem. When metadata is being replicated and we're doing multiple
   journal writes with the same sequence number - and thus nonce - we really are
   writing the same data (we only checksum once, not once per write).

 * Btree nodes concatenate a few things for the nonce:
   - A 64 bit random integer, which is generated per btree node (but btree nodes
     are log structured, so entries within a given btree node share the same
     integer).
   - A journal sequence number. For btree node writes done at around the same
     point in time, this field can be identical in unrelated btree node writes -
     but only for btree nodes writes done relatively close in time, so the
     journal sequence number plus the previous random integer should be more
     than sufficient entropy.
   - And lastly the offset within the btree node, so that btree node entries
     sharing the same random integer are guaranteed a different nonce.

 * Allocation information (struct prio_set):
   bcache/bcachefs doesn't have allocation information persisted like other
   filesystems, but this is our closest equivalent - this structure mainly
   stores generation numbers that correspond to extent pointers.

   Allocation information uses a dedicated randomly generated 96 bit nonce
   field.

### Data

Data writes have no unencrypted header: checksums/MACs, nonces, etc. are stored
with the pointers, ZFS style.

Bcache/bcachefs is extent based, not block based: pointers point to variable
sized chunks of data, and we store one checksum/MAC per extent, not per block: a
checksum or MAC might cover up to 64k (extents that aren't checksummed or
compressed may be larger). Nonces are thus also per extent, not per block.

Currently, the Poly1305 MAC is truncated to 64 bits - due to a desire not to
inflate our metadata any more than necessary. Guidance from cryptographers is
requested as to whether this is a reasonable option; do note that the MAC is not
stored with the data, but is itself stored encrypted elsewhere in the btree. We
do already have different fields for storing 4 byte checksums and 8 byte
checksums; it will be a trivial matter to add a field allowing 16 byte checksums
to be stored, and we will add that anyways - so this isn't a pressing design
issue, this is just a matter of what the defaults should be and what we should
tell users.

#### Extent nonces

We don't wish to simply add a random 96 bit nonce to every extent - that would
inflate our metadata size by a very significant amount. Instead, keys (of which
extents are a subset) have a 96 bit version number field; when encryption is
enabled, we ensure that version numbers are enabled and every new extent gets a
new, unique version number.

However, extents may be partially overwritten or split, and then to defragment
we may have to rewrite those partially overwritten extents elsewhere. We cannot
simply pick a new version number when we rewrite an extent - that would break
semantics other uses of version numbers expect.

When we rewrite an extent, we only write the currently live portions of the
extent - we don't rewrite the parts that were overwritten. We can't write it out
with the same nonce as the original extent.

If we concatenated the version number with the offset within the file, and the
extent's current size - that would work, except that it would break fcollapse(),
which moves extents to a new position within a file. We are forced to add some
additional state to extents.

We could add a small counter that is incremented every time the size of an
extent is reduced (and the data it points to changes); we can easily bound the
size of the counter we need by the maximum size of a checksummed extent. But
this approach fails when extents are split.

What can work is if we add a field for "offset from the start of the original
extent to the start of the current extent" - updating that field whenever we
trim the front of an extent.

If we have that, then we could simply skip ahead in the keystream to where the
currently live data lived in the original extent - there's no problem with nonce
reuse if you're encrypting exactly the same data. Except - that fails with
compression, since if we take an extent, drop the first 4k, and compress it,
that won't give the same data as if we compress it and then drop the first 4k of
the compressed data.

The approach almost works though, if we take that offset and use it as part of
our nonce: what we want to do is construct a function that will output the same
nonce iff two extents (fragments of the same original extent) really are the
same data.

Offset into the original extent works in the absence of compression - two
fragments with the same offset but different sizes will be equal in their common
prefix, ignoring compression. We can handle compression if we also include both
the current size, and the current compression function - offset + current size
uniquely determines the uncompressed data, so, offset + current size +
compression function will uniquely determine the compressed output.

#### Nonce reuse on startup

After recovery, we must ensure we don't reuse existing version numbers - we must
ensure that newly allocated version numbers are strictly greater than any
version number that has every been used before.

The problem here is that we use the version number to write the data before
adding the extent with that version number to the btree: after unclean shutdown,
there will have been version numbers used to write data for which we have no
record in the btree.

The rigorous solution to this is to add a field (likely to the journal header)
that indicates version numbers smaller than that field may have been used.
However, we don't do that yet - it's not completely trivial since it'll add
another potential dependency in the IO path that needs some analysis.

The current solution implemented by the code is to scan every existing version
number (as part of an existing pass), and set the next version number to
allocate to be 64k greater than the highest existing version number that was
found.
