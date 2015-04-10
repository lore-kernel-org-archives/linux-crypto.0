From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto/arm: accelerated SHA-512 using ARM generic ASM and NEON
Date: Fri, 10 Apr 2015 22:23:32 +0200
Message-ID: <F695F357-2A5C-4DFC-9F0E-188CDBBE7C01@linaro.org>
References: <1428676148-28210-1-git-send-email-ard.biesheuvel@linaro.org> <5553652.sur4tr0YJi@wuerfel>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"samitolvanen@google.com" <samitolvanen@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37390 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbbDJUXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 16:23:38 -0400
Received: by wiaa2 with SMTP id a2so9630384wia.0
        for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2015 13:23:37 -0700 (PDT)
In-Reply-To: <5553652.sur4tr0YJi@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> On 10 apr. 2015, at 22:08, Arnd Bergmann <arnd@arndb.de> wrote:
> 
>> On Friday 10 April 2015 16:29:08 Ard Biesheuvel wrote:
>> +#if __ARM_MAX_ARCH__>=7
>> +.arch  armv7-a
>> +.fpu   neon
>> +
> 
> This will cause a build failure on an ARMv7-M build, which is incompatible
> with .arch  armv7-a and .fpu   neon.
> 

The neon part depends on CONFIG_KERNEL_MODE_NEON, which would never be set for that platform, I suppose