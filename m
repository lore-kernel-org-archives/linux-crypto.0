From: Benny Halevy <bhalevy@panasas.com>
Subject: Fwd: Re: [PATCH] iSCSI fix endieness of digest to be network byte
 order
Date: Wed, 07 Nov 2007 21:04:52 +0200
Message-ID: <47320C54.10406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Mike Christie <michaelc@cs.wisc.edu>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sa8.bezeqint.net ([192.115.104.22]:55187 "EHLO sa8.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbXKGTu2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Nov 2007 14:50:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am I dreaming (or just sleep deprived ;), or crc32c swabs the crc
one too many times on big-endian machines when CRC_LE_BITS != 1?

If I understand the api design correctly crypto_hash-{digest,final}
are supposed to prepare the digest as a byte string in network order 
rather than a number in cpu order but the internal state can
be kept in cpu order.  It seems like crc32c_le was intended to
be called directly in the past (in the CRC_LE_BITS != 1 case) and
therefore it returns the result in network order.  The question is if this
property should be maintained or not, and if not, then chksum_final() in
crypto/crc32c.c should not swab the result


-       *(__le32 *)out = ~cpu_to_le32(mctx->crc);
+       *(__le32 *)out = ~mctx->crc;

(plus crc32c_[lb]e implementation for CRC_BE_BITS == 1 should also
swab the crc before and after doing their dance)

The other approach is demonstrated in the patch below which
always keeps the intermediate crc state in cpu order and
swabs it only when returned to the caller as a digest.

Benny

On Nov. 07, 2007, 17:30 +0200, Benny Halevy <bhalevy@panasas.com> wrote:
> On Nov. 07, 2007, 17:11 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
>> On Wed, 07 Nov 2007 17:02:31 +0200
>> Benny Halevy <bhalevy@panasas.com> wrote:
>>
>>> Mike, it looks like the implementation of crc32c_le already
>>> computes the crc in the "right" byte order so you can just
>>> store it from LE machines, so I suspect that on BE machines
>>> it gets swabbed when stored onto the buffer.
>>> [phew... the existing implementation apparently comply with the standard]
>>>
>>> The patch below stores the cpu_to_le32 of the computed crc
>>> so it will get swabbed on BE architectures.
>>>
>>> I checked the digest on a LE machine and it agrees with
>>> a reference implementation that agrees with rfc3720
>>> on the examples given in their :)  can you please
>>> test it with a BE initiator?
>> Hmm, haven't you read the followings?
>>
>> http://www.nabble.com/Re%3A--Fwd%3A-what-is-the-endian-of-header-digest-and-data-digest---p13535071.html
>>
>> and
>>
>> http://www.nabble.com/Re%3A--Fwd%3A-what-is-the-endian-of-header-digest-and-data-digest---p13605311.html
>>
> 
> I missed that. Sorry for the spam then.
> Just by comparing the result of the algorithm to the examples in rfc3720
> the call to cpu_to_le32 in chksum_final() apparently must be there
> 
> and the same for the swab in the ISCSI_BIG_ENDIAN case in
> http://linux-iscsi.org/svn/trunk/target/common/iscsi_crc.c

Tomo, looking at libcrc32c, when CRC_LE_BITS == 8
crc32c_le keeps its state in network order unlike CRC_LE_BITS == 1
for every update it will swab the state on BE machine do the
calculation and return the swabbed result that chksum_update
stores in mctx->crc. Finally chksum_final swabs the result
again.  Note that since the initial state is ~0 the first swab in crc32c_le
(where CRC_LE_BITS == 8) the first swab is a no-op.

If I'm not wrong the correct fix would be 

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 60f4680..b8d379b 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -163,13 +163,13 @@ static const u32 crc32c_table[256] = {
 u32 __attribute_pure__
 crc32c_le(u32 seed, unsigned char const *data, size_t length)
 {
-       u32 crc = __cpu_to_le32(seed);
+       u32 crc = seed;

        while (length--)
                crc =
                    crc32c_table[(crc ^ *data++) & 0xFFL] ^ (crc >> 8);

-       return __le32_to_cpu(crc);
+       return crc;
 }

 #endif /* CRC_LE_BITS == 8 */

rather than not doing the swab in chksum_final in order to be compatible
with the CRC_LE_BITS == 1 case and overall this results in fewer swabs
for multiple crypto_hash_updates.


> 
> Benny
