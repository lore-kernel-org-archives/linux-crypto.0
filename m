From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: vmx: Remove dubiously licensed crypto code
Date: Wed, 29 Mar 2017 16:08:01 -0700
Message-ID: <7ec54553-610c-a5dc-d4d9-3c83f6a161d9@linux.vnet.ibm.com>
References: <20170329125639.14288-1-msuchanek@suse.de>
 <20170329145135.GA28057@kroah.com> <20170329171327.38d4fdd6@kitsune.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linux-crypto@vger.kernel.org,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
To: =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170329171327.38d4fdd6@kitsune.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/29/2017 08:13 AM, Michal Suchánek wrote:
> On Wed, 29 Mar 2017 16:51:35 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
>> On Wed, Mar 29, 2017 at 02:56:39PM +0200, Michal Suchanek wrote:
>>> While reviewing commit 11c6e16ee13a ("crypto: vmx - Adding asm
>>> subroutines for XTS") which adds the OpenSSL license header to
>>> drivers/crypto/vmx/aesp8-ppc.pl licensing of this driver came into
>>> qestion. The whole license reads:
>>>
>>>  # Licensed under the OpenSSL license (the "License").  You may not
>>> use # this file except in compliance with the License.  You can
>>> obtain a # copy
>>>  # in the file LICENSE in the source distribution or at
>>>  # https://www.openssl.org/source/license.html
>>>
>>>  #
>>>  #
>>> ====================================================================
>>> # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL #
>>> project. The module is, however, dual licensed under OpenSSL and #
>>> CRYPTOGAMS licenses depending on where you obtain it. For further #
>>> details see http://www.openssl.org/~appro/cryptogams/. #
>>> ====================================================================
>>>
>>> After seeking legal advice it is still not clear that this driver
>>> can be legally used in Linux. In particular the "depending on where
>>> you obtain it" part does not make it clear when you can apply the
>>> GPL and when the OpenSSL license.
>>>
>>> I tried contacting the author of the code for clarification but did
>>> not hear back. In absence of clear licensing the only solution I
>>> see is removing this code.

A quick 'git grep OpenSSL' of the Linux tree returns several other
crypto files under the ARM architecture that are similarly licensed. Namely:

arch/arm/crypto/sha1-armv4-large.S
arch/arm/crypto/sha256-armv4.pl
arch/arm/crypto/sha256-core.S_shipped
arch/arm/crypto/sha512-armv4.pl
arch/arm/crypto/sha512-core.S_shipped
arch/arm64/crypto/sha256-core.S_shipped
arch/arm64/crypto/sha512-armv8.pl
arch/arm64/crypto/sha512-core.S_shipped

On closer inspection of some of those files have the addendum that
"Permission to use under GPL terms is granted", but not all of them.

-Tyrel
