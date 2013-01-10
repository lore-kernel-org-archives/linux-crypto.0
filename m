From: Alexander Boyko <alexander_boyko@xyratex.com>
Subject: Re: [PATCH v4] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Thu, 10 Jan 2013 23:26:24 +0400
Message-ID: <50EF15E0.5060204@xyratex.com>
References: <50EED427.2040309@xyratex.com>  <50EED643.2010907@xyratex.com> <1357840496.17632.119.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Dilger <adilger@whamcloud.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63172 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3AJT0a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2013 14:26:30 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so543806bkw.19
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2013 11:26:29 -0800 (PST)
In-Reply-To: <1357840496.17632.119.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

1/10/13 9:54 PM, Tim Chen =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>
> On Thu, 2013-01-10 at 18:54 +0400, Alexander Boyko wrote:
>> From: Alexander Boyko <alexander_boyko@xyratex.com>
>>
>> This patch adds crc32 algorithms to shash crypto api. One is wrapper=
 to
>> gerneric crc32_le function. Second is crc32 pclmulqdq implementation=
=2E It
>> use hardware provided PCLMULQDQ instruction to accelerate the CRC32 =
disposal.
>> This instruction present from Intel Westmere and AMD Bulldozer CPUs.
>>
>> For intel core i5 I got 450MB/s for table implementation and 2100MB/=
s=20
>> for pclmulqdq implementation (
> Alexander,
>
> Wonder if you have a chance to test performance of our PCLMULQDQ
> implementation for crc32c that's in the current code (see
> crc32c-pcl-intel-asm_64.asm). The throughput will probably be compara=
ble
> with your implementation.
>
> Tim
>
>
>
I have no chance to test crc32c pclmul, but I tested previous crc32c
implementation on crc32 instruction, the speed was about 2500 MB/s. So,
I think, the newest version should be faster.
