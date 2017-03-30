From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: vmx: Remove dubiously licensed crypto code
Date: Thu, 30 Mar 2017 13:30:17 -0300
Message-ID: <8591ac8ff6ef6fa9c4bd264017ac360d@linux.vnet.ibm.com>
References: <20170329125639.14288-1-msuchanek@suse.de>
 <20170329145135.GA28057@kroah.com> <20170329171327.38d4fdd6@kitsune.suse.cz>
 <7ec54553-610c-a5dc-d4d9-3c83f6a161d9@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Cc: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linux-crypto@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933794AbdC3Q0m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Mar 2017 12:26:42 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2UGNhZm004710
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2017 12:26:41 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29h4ek3pjc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2017 12:26:40 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
        Thu, 30 Mar 2017 12:26:40 -0400
In-Reply-To: <7ec54553-610c-a5dc-d4d9-3c83f6a161d9@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2017-03-29 20:08, Tyrel Datwyler wrote:
> On 03/29/2017 08:13 AM, Michal Suchánek wrote:
>> On Wed, 29 Mar 2017 16:51:35 +0200
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> 
>>> On Wed, Mar 29, 2017 at 02:56:39PM +0200, Michal Suchanek wrote:
>>>> While reviewing commit 11c6e16ee13a ("crypto: vmx - Adding asm
>>>> subroutines for XTS") which adds the OpenSSL license header to
>>>> drivers/crypto/vmx/aesp8-ppc.pl licensing of this driver came into
>>>> qestion. The whole license reads:
>>>> 
>>>>  # Licensed under the OpenSSL license (the "License").  You may not
>>>> use # this file except in compliance with the License.  You can
>>>> obtain a # copy
>>>>  # in the file LICENSE in the source distribution or at
>>>>  # https://www.openssl.org/source/license.html
>>>> 
>>>>  #
>>>>  #
>>>> ====================================================================
>>>> # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL #
>>>> project. The module is, however, dual licensed under OpenSSL and #
>>>> CRYPTOGAMS licenses depending on where you obtain it. For further #
>>>> details see http://www.openssl.org/~appro/cryptogams/. #
>>>> ====================================================================
>>>> 
>>>> After seeking legal advice it is still not clear that this driver
>>>> can be legally used in Linux. In particular the "depending on where
>>>> you obtain it" part does not make it clear when you can apply the
>>>> GPL and when the OpenSSL license.
>>>> 
>>>> I tried contacting the author of the code for clarification but did
>>>> not hear back. In absence of clear licensing the only solution I
>>>> see is removing this code.
> 
> A quick 'git grep OpenSSL' of the Linux tree returns several other
> crypto files under the ARM architecture that are similarly licensed. 
> Namely:
> 
> arch/arm/crypto/sha1-armv4-large.S
> arch/arm/crypto/sha256-armv4.pl
> arch/arm/crypto/sha256-core.S_shipped
> arch/arm/crypto/sha512-armv4.pl
> arch/arm/crypto/sha512-core.S_shipped
> arch/arm64/crypto/sha256-core.S_shipped
> arch/arm64/crypto/sha512-armv8.pl
> arch/arm64/crypto/sha512-core.S_shipped
> 
> On closer inspection of some of those files have the addendum that
> "Permission to use under GPL terms is granted", but not all of them.
> 
> -Tyrel

In 2015, Andy Polyakov, the author, replied in this mailing list [1]:

"I have no problems with reusing assembly modules in kernel context. The
whole idea behind cryptogams initiative was exactly to reuse code in
different contexts."

[1] https://patchwork.kernel.org/patch/6027481/

-- 
Paulo Flabiano Smorigo
IBM Linux Technology Center
