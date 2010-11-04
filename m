From: Nicolas Kaiser <nikai@nikai.net>
Subject: Re: [PATCH] crypto: cast5: simplify if-statements
Date: Thu, 4 Nov 2010 16:14:53 +0100
Message-ID: <20101104161453.5e257b18@absol.kitzblitz>
References: <20101027120324.0b12a8b8@absol.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:39530 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969Ab0KDPQx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 11:16:53 -0400
Received: from absol.kitzblitz ([91.119.3.34])
	(authenticated bits=0)
	by webhosting01.bon.m2soft.com (8.13.8/8.13.8) with ESMTP id oA4FFNdZ029062
	for <linux-crypto@vger.kernel.org>; Thu, 4 Nov 2010 16:15:24 +0100
In-Reply-To: <20101027120324.0b12a8b8@absol.kitzblitz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Nicolas Kaiser <nikai@nikai.net>:
> I noticed that by factoring out common rounds from the
> branches of the if-statements in the encryption and
> decryption functions, the executable file size goes down
> significantly, for crypto/cast5.ko from 26688 bytes
> to 24336 bytes (amd64).
> 
> On my test system, I saw a slight speedup.

Hi there!

How would I add a simple cast5 cipher speed test to tcrypt.c, like this?
	case 14:
		test_cipher_speed("ecb(cast5)", ENCRYPT, sec, NULL, 0,
				  speed_template_8);
		test_cipher_speed("ecb(cast5)", DECRYPT, sec, NULL, 0,
				  speed_template_8);
		test_cipher_speed("cbc(cast5)", ENCRYPT, sec, NULL, 0,
				  speed_template_8);
		test_cipher_speed("cbc(cast5)", DECRYPT, sec, NULL, 0,
				  speed_template_8);
		break;

Does that make sense? Here are my results:
# insmod crypto/tcrypt.ko mode=14 sec=30

Before:
testing speed of ecb(cast5) encryption
test 0 (64 bit key, 16 byte blocks): 118241789 operations in 30 seconds (1891868624 bytes)
test 1 (64 bit key, 64 byte blocks): 40502820 operations in 30 seconds (2592180480 bytes)
test 2 (64 bit key, 256 byte blocks): 11111145 operations in 30 seconds (2844453120 bytes)
test 3 (64 bit key, 1024 byte blocks): 2858271 operations in 30 seconds (2926869504 bytes)
test 4 (64 bit key, 8192 byte blocks): 359327 operations in 30 seconds (2943606784 bytes)

testing speed of ecb(cast5) decryption
test 0 (64 bit key, 16 byte blocks): 118443232 operations in 30 seconds (1895091712 bytes)
test 1 (64 bit key, 64 byte blocks): 40060571 operations in 30 seconds (2563876544 bytes)
test 2 (64 bit key, 256 byte blocks): 10944717 operations in 30 seconds (2801847552 bytes)
test 3 (64 bit key, 1024 byte blocks): 2811154 operations in 30 seconds (2878621696 bytes)
test 4 (64 bit key, 8192 byte blocks): 353043 operations in 30 seconds (2892128256 bytes)

testing speed of cbc(cast5) encryption
test 0 (64 bit key, 16 byte blocks): 110614202 operations in 30 seconds (1769827232 bytes)
test 1 (64 bit key, 64 byte blocks): 37260496 operations in 30 seconds (2384671744 bytes)
test 2 (64 bit key, 256 byte blocks): 10323268 operations in 30 seconds (2642756608 bytes)
test 3 (64 bit key, 1024 byte blocks): 2650259 operations in 30 seconds (2713865216 bytes)
test 4 (64 bit key, 8192 byte blocks): 333281 operations in 30 seconds (2730237952 bytes)

testing speed of cbc(cast5) decryption
test 0 (64 bit key, 16 byte blocks): 102455488 operations in 30 seconds (1639287808 bytes)
test 1 (64 bit key, 64 byte blocks): 35507599 operations in 30 seconds (2272486336 bytes)
test 2 (64 bit key, 256 byte blocks): 9962653 operations in 30 seconds (2550439168 bytes)
test 3 (64 bit key, 1024 byte blocks): 2569557 operations in 30 seconds (2631226368 bytes)
test 4 (64 bit key, 8192 byte blocks): 323085 operations in 30 seconds (2646712320 bytes)

 that's in sum:
87993190 bytes/s
86877105 bytes/s
81609058 bytes/s
78267680 bytes/s


After:
testing speed of ecb(cast5) encryption
test 0 (64 bit key, 16 byte blocks): 120033632 operations in 30 seconds (1920538112 bytes)
test 1 (64 bit key, 64 byte blocks): 41484473 operations in 30 seconds (2655006272 bytes)
test 2 (64 bit key, 256 byte blocks): 11418041 operations in 30 seconds (2923018496 bytes)
test 3 (64 bit key, 1024 byte blocks): 2940940 operations in 30 seconds (3011522560 bytes)
test 4 (64 bit key, 8192 byte blocks): 369831 operations in 30 seconds (3029655552 bytes)

testing speed of ecb(cast5) decryption
test 0 (64 bit key, 16 byte blocks): 122215696 operations in 30 seconds (1955451136 bytes)
test 1 (64 bit key, 64 byte blocks): 41845591 operations in 30 seconds (2678117824 bytes)
test 2 (64 bit key, 256 byte blocks): 11478322 operations in 30 seconds (2938450432 bytes)
test 3 (64 bit key, 1024 byte blocks): 2952595 operations in 30 seconds (3023457280 bytes)
test 4 (64 bit key, 8192 byte blocks): 371305 operations in 30 seconds (3041730560 bytes)

testing speed of cbc(cast5) encryption
test 0 (64 bit key, 16 byte blocks): 112301700 operations in 30 seconds (1796827200 bytes)
test 1 (64 bit key, 64 byte blocks): 38131586 operations in 30 seconds (2440421504 bytes)
test 2 (64 bit key, 256 byte blocks): 10609299 operations in 30 seconds (2715980544 bytes)
test 3 (64 bit key, 1024 byte blocks): 2728723 operations in 30 seconds (2794212352 bytes)
test 4 (64 bit key, 8192 byte blocks): 343249 operations in 30 seconds (2811895808 bytes)

testing speed of cbc(cast5) decryption
test 0 (64 bit key, 16 byte blocks): 106721453 operations in 30 seconds (1707543248 bytes)
test 1 (64 bit key, 64 byte blocks): 37573333 operations in 30 seconds (2404693312 bytes)
test 2 (64 bit key, 256 byte blocks): 10624511 operations in 30 seconds (2719874816 bytes)
test 3 (64 bit key, 1024 byte blocks): 2745305 operations in 30 seconds (2811192320 bytes)
test 4 (64 bit key, 8192 byte blocks): 345642 operations in 30 seconds (2831499264 bytes)

 that's in sum:
90264940 bytes/s
90914715 bytes/s
83728916 bytes/s
83165353 bytes/s


Best regards,
Nicolas Kaiser
