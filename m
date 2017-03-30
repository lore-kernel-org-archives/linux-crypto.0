From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: vmx: Remove dubiously licensed crypto code
Date: Wed, 29 Mar 2017 17:49:16 -0700
Message-ID: <cc19b8c8-23d4-444a-b873-253ead0a26da@linux.vnet.ibm.com>
References: <20170329125639.14288-1-msuchanek@suse.de>
 <87r31flisi.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>,
        Michal Suchanek <msuchanek@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        appro@openssl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87r31flisi.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/29/2017 05:17 PM, Michael Ellerman wrote:
> Michal Suchanek <msuchanek@suse.de> writes:
> 
>> While reviewing commit 11c6e16ee13a ("crypto: vmx - Adding asm
>> subroutines for XTS") which adds the OpenSSL license header to
>> drivers/crypto/vmx/aesp8-ppc.pl licensing of this driver came into
>> qestion. The whole license reads:
>>
>>  # Licensed under the OpenSSL license (the "License").  You may not use
>>  # this file except in compliance with the License.  You can obtain a
>>  # copy
>>  # in the file LICENSE in the source distribution or at
>>  # https://www.openssl.org/source/license.html
>>
>>  #
>>  # ====================================================================
>>  # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
>>  # project. The module is, however, dual licensed under OpenSSL and
>>  # CRYPTOGAMS licenses depending on where you obtain it. For further
>>  # details see http://www.openssl.org/~appro/cryptogams/.
>>  # ====================================================================
>>
>> After seeking legal advice it is still not clear that this driver can be
>> legally used in Linux. In particular the "depending on where you obtain
>> it" part does not make it clear when you can apply the GPL and when the
>> OpenSSL license.
> 
> It seems pretty clear to me that the intention is that the CRYPTOGAM
> license applies.
> 
> If you visit it's URL it includes:
> 
>   ALTERNATIVELY, provided that this notice is retained in full, this
>   product may be distributed under the terms of the GNU General Public
>   License (GPL), in which case the provisions of the GPL apply INSTEAD OF
>   those given above.
> 
> 
> I agree that the text in the file is not sufficiently clear about what
> license applies, but I'm unconvinced that there is any code here that is
> actually being distributed incorrectly.

The original commit message also outlines that the authors collaborated
directly with Andy.

commit 5c380d623ed30b71a2441fb4f2e053a4e1a50794
Author: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
Date:   Fri Feb 6 14:59:35 2015 -0200

    crypto: vmx - Add support for VMS instructions by ASM

    OpenSSL implements optimized ASM algorithms which support
    VMX instructions on Power 8 CPU.

    These scripts generate an endian-agnostic ASM implementation
    in order to support both big and little-endian.
        - aesp8-ppc.pl: implements suport for AES instructions
        implemented by POWER8 processor.
        - ghashp8-ppc.pl: implements support for  GHASH for Power8.
        - ppc-xlate.pl:  ppc assembler distiller.

    These code has been adopted from OpenSSL project in collaboration
    with the original author (Andy Polyakov <appro@openssl.org>).

    Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

-Tyrel

> 
> Getting the text in the header changed to be clearer seems like the
> obvious solution.
> 
>> I tried contacting the author of the code for clarification but did not
>> hear back. In absence of clear licensing the only solution I see is
>> removing this code.
> 
> Did you try contacting anyone else? Like perhaps the powerpc or crypto
> maintainers, or anyone else who's worked on the driver?
> 
> Sending a patch to delete all the code clearly works to get people's
> attention, I'll give you that.
> 
