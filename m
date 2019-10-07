Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4F5C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 21:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FBB621721
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 21:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="E8IDkSJU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfJGVCo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 17:02:44 -0400
Received: from mx.0dd.nl ([5.2.79.48]:58686 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbfJGVCo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 17:02:44 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 320F85FBBE;
        Mon,  7 Oct 2019 23:02:43 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="E8IDkSJU";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id E697A3BFC2;
        Mon,  7 Oct 2019 23:02:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com E697A3BFC2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1570482162;
        bh=J2mFnNzNsOACS8MHQSlK+0G9XozW1c21PbHKFP0Zmd8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8IDkSJULi04CfbNsvp5CQlRdbB0iNkXrKd17qXTm5JfUJ99G9NCZ+D68l1O4D9V7
         IUgJLx+tdEWPJcBAFsUJnm7UccpYrVaRqP5wxrMPDJomB5ioYgp1s3t0wlFVoblFZl
         en7CpVy3ojZhCdjdQV24njY4IcyO4fr90Ux/GO5v7AAk64VXPNAl2lja/OHdGrPAyd
         u4g1xjMuc/1bY/7stTOLPmLHk7oRymuEVSU/M2jMq3VPewTeNzdxGCxecL2ra1IMqo
         mPaJmLIrVqrPG6SDFu3rJiE72vooZ7O/0fonKI1ZS5vyV8U3xjnOLA+IWaSF9gQDvp
         ehMsFQiS4cwuQ==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Mon, 07 Oct 2019 21:02:42 +0000
Date:   Mon, 07 Oct 2019 21:02:42 +0000
Message-ID: <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Andy Polyakov <appro@cryptogams.org>
Subject: Re: [PATCH v3 19/29] crypto: mips/poly1305 - incorporate
 OpenSSL/CRYPTOGAMS optimized implementation
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-20-ard.biesheuvel@linaro.org>
In-Reply-To: <20191007164610.6881-20-ard.biesheuvel@linaro.org>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Ard Biesheuvel <ard.biesheuvel@linaro.org>:

> This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305 implementation
> for MIPS authored by Andy Polyakov, and contributed by him to the OpenSSL
> project. The file 'poly1305-mips.pl' is taken straight from this upstream
> GitHub repository [0] at commit 57c3a63be70b4f68b9eec1b043164ea790db6499,
> and already contains all the changes required to build it as part of a
> Linux kernel module.
>
> [0] https://github.com/dot-asm/cryptogams
>
> Co-developed-by: Andy Polyakov <appro@cryptogams.org>
> Signed-off-by: Andy Polyakov <appro@cryptogams.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/mips/crypto/Makefile         |   14 +
>  arch/mips/crypto/poly1305-glue.c  |  203 ++++
>  arch/mips/crypto/poly1305-mips.pl | 1246 ++++++++++++++++++++
>  crypto/Kconfig                    |    6 +
>  4 files changed, 1469 insertions(+)
>
> <snip>

Hi Ard,

Is it also an option to include my mip32r2 optimized poly1305 version?

Below the results which shows a good improvement over the Andy  
Polyakov version.
I swapped the poly1305 assembly file and rename the function to  
<func_name>_mips
Full WireGuard source with the changes [0]

bytes |  RvD | openssl | delta | delta / openssl
     0 |  155 |   168   |   -13 |  -7,74%
     1 |  260 |   283   |   -23 |  -8,13%
    16 |  215 |   236   |   -21 |  -8,90%
    64 |  321 |   373   |   -52 | -13,94%
   576 | 1440 |  1813   |  -373 | -20,57%
  1280 | 2987 |  3801   |  -814 | -21,42%
  1408 | 3268 |  4161   |  -893 | -21,46%
  1420 | 3362 |  4267   |  -905 | -21,21%
  1440 | 3337 |  4250   |  -913 | -21,48%
  1536 | 3545 |  4531   |  -986 | -21,76%
  4096 | 9160 | 11755   | -2595 | -22,08%


Wireguard speedbench with my poly1305 implementation
[  412.010349] wireguard: chacha20 self-tests: pass
[  412.038265] wireguard: poly1305 self-tests: pass
[  412.050422] wireguard: chacha20poly1305 self-tests: pass
[  412.268724] wireguard: chacha20poly1305_encrypt:    1 bytes,        
0.252 MB/sec,     1603 cycles
[  412.488506] wireguard: chacha20poly1305_encrypt:   16 bytes,        
4.159 MB/sec,     1558 cycles
[  412.709162] wireguard: chacha20poly1305_encrypt:   64 bytes,       
15.356 MB/sec,     1696 cycles
[  412.932366] wireguard: chacha20poly1305_encrypt:  128 bytes,       
22.033 MB/sec,     2385 cycles
[  413.229175] wireguard: chacha20poly1305_encrypt: 1420 bytes,       
35.480 MB/sec,    16740 cycles
[  413.519035] wireguard: chacha20poly1305_encrypt: 1440 bytes,       
36.117 MB/sec,    16706 cycles
[  413.737346] wireguard: chacha20poly1305_decrypt:    1 bytes,        
0.246 MB/sec,     1654 cycles
[  413.957112] wireguard: chacha20poly1305_decrypt:   16 bytes,        
4.045 MB/sec,     1605 cycles
[  414.177758] wireguard: chacha20poly1305_decrypt:   64 bytes,       
14.953 MB/sec,     1744 cycles
[  414.400964] wireguard: chacha20poly1305_decrypt:  128 bytes,       
21.642 MB/sec,     2434 cycles
[  414.687803] wireguard: chacha20poly1305_decrypt: 1420 bytes,       
35.480 MB/sec,    16787 cycles
[  414.977636] wireguard: chacha20poly1305_decrypt: 1440 bytes,       
35.979 MB/sec,    16754 cycles
[  415.190375] wireguard: poly1305:    0 bytes,       0.000 MB/sec,     
   155 cycles
[  415.400864] wireguard: poly1305:    1 bytes,       1.375 MB/sec,     
   260 cycles
[  415.610655] wireguard: poly1305:   16 bytes,      25.817 MB/sec,     
   215 cycles
[  415.821149] wireguard: poly1305:   64 bytes,      72.936 MB/sec,     
   321 cycles
[  416.036357] wireguard: poly1305:  576 bytes,     162.047 MB/sec,     
  1440 cycles
[  416.263561] wireguard: poly1305: 1280 bytes,     177.124 MB/sec,     
  2987 cycles
[  416.484869] wireguard: poly1305: 1408 bytes,     178.320 MB/sec,     
  3268 cycles
[  416.715311] wireguard: poly1305: 1420 bytes,     174.693 MB/sec,     
  3362 cycles
[  416.945195] wireguard: poly1305: 1440 bytes,     178.527 MB/sec,     
  3337 cycles
[  417.176158] wireguard: poly1305: 1536 bytes,     179.296 MB/sec,     
  3545 cycles
[  417.432304] wireguard: poly1305: 4096 bytes,     186.718 MB/sec,     
  9160 cycles

Wireguard speedbench with the openssl poly1305 implementation
[  707.579242] wireguard: chacha20 self-tests: pass
[  707.610460] wireguard: poly1305 self-tests: pass
[  707.622678] wireguard: chacha20poly1305 self-tests: pass
[  707.838929] wireguard: chacha20poly1305_encrypt:    1 bytes,        
0.247 MB/sec,     1638 cycles
[  708.058698] wireguard: chacha20poly1305_encrypt:   16 bytes,        
4.072 MB/sec,     1590 cycles
[  708.279486] wireguard: chacha20poly1305_encrypt:   64 bytes,       
14.776 MB/sec,     1758 cycles
[  708.502893] wireguard: chacha20poly1305_encrypt:  128 bytes,       
21.105 MB/sec,     2490 cycles
[  708.803678] wireguard: chacha20poly1305_encrypt: 1420 bytes,       
33.583 MB/sec,    17695 cycles
[  709.103566] wireguard: chacha20poly1305_encrypt: 1440 bytes,       
34.194 MB/sec,    17669 cycles
[  709.327515] wireguard: chacha20poly1305_decrypt:    1 bytes,        
0.240 MB/sec,     1684 cycles
[  709.547304] wireguard: chacha20poly1305_decrypt:   16 bytes,        
3.963 MB/sec,     1638 cycles
[  709.768088] wireguard: chacha20poly1305_decrypt:   64 bytes,       
14.404 MB/sec,     1805 cycles
[  709.991500] wireguard: chacha20poly1305_decrypt:  128 bytes,       
20.739 MB/sec,     2534 cycles
[  710.282292] wireguard: chacha20poly1305_decrypt: 1420 bytes,       
33.583 MB/sec,    17740 cycles
[  710.582175] wireguard: chacha20poly1305_decrypt: 1440 bytes,       
34.057 MB/sec,    17718 cycles
[  710.800476] wireguard: poly1305:    0 bytes,       0.000 MB/sec,     
   168 cycles
[  711.011010] wireguard: poly1305:    1 bytes,       1.277 MB/sec,     
   283 cycles
[  711.220790] wireguard: poly1305:   16 bytes,      23.590 MB/sec,     
   236 cycles
[  711.431430] wireguard: poly1305:   64 bytes,      63.702 MB/sec,     
   373 cycles
[  711.648132] wireguard: poly1305:  576 bytes,     129.473 MB/sec,     
  1813 cycles
[  711.877393] wireguard: poly1305: 1280 bytes,     139.404 MB/sec,     
  3801 cycles
[  712.109065] wireguard: poly1305: 1408 bytes,     140.185 MB/sec,     
  4161 cycles
[  712.339563] wireguard: poly1305: 1420 bytes,     137.994 MB/sec,     
  4267 cycles
[  712.569491] wireguard: poly1305: 1440 bytes,     140.349 MB/sec,     
  4250 cycles
[  712.800790] wireguard: poly1305: 1536 bytes,     140.917 MB/sec,     
  4531 cycles
[  713.064421] wireguard: poly1305: 4096 bytes,     145.703 MB/sec,     
11755 cycles

Greats,

René

[0]: https://github.com/vDorst/wireguard/commits/mips-bench






