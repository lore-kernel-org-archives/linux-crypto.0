From: levent demir <levent.demir@inria.fr>
Subject: Atmel driver - XTS mode - Alignement issue
Date: Tue, 31 May 2016 09:54:46 +0200
Message-ID: <1464681286.9080.15.camel@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57497
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755772AbcEaHys (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 03:54:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all, 

I am working on SAMA5D3 board with atmel-aes driver, I have a question
about sg. 

This board does not support XTS mode, however we want to add this
functionality. 


As a recall XTS mode : 

For a 512 bytes block:

1) We encrypt the given IV with the second part of the key [ECB]. 
2) We compute the 32 tweaks value (with GF multiplication)
3) We Xor the plaintext with the tweaks (called XOR_1)
4) We encrypt the result with ECB and the first half of the key
5) Again we xor the result with tweaks (called XOR_2)

So if I want to add my own XTS mode I need to make all those
operations. 

I have seen in the code there is a alignement issue to handle, if source
data is aligned 
we can encrypt it directly. If  source data is not aligned we call a
function to copy into a buffer : 

625	if (!src_aligned) {
626            sg_copy_to_buffer(src, sg_nents(src), dd->buf, len);
			    ...

Moreover we are working with dm-crypt. 

My question is : is it possible to make the XOR operation directly on
scatterlist if data is aligned ?
Or I am forced to use the sg_copy_to/from_buffer.

We have tested and here are the results :

1) The easy solution is to copy the src data into the buffer and to xor
it with tweaks for XOR_1 and XOR_2
2) If we xor only the ciphertext [dst] (XOR_2) directly with the
scatterlist and compute the src XOR_1 with the buffer, it is working. 
3) If we xor direcly with the scatterlist for XOR_1 and XOR_2 we have an
error at the mount step using dm-crypt :

[269132.780000] EXT4-fs (dm-0): ext4_check_descriptors: Block bitmap for
group 0 not in group
(block 16843203)!
[269132.790000] EXT4-fs (dm-0): group descriptors corrupted! 


If you can help me on this point. 

Thanks.
