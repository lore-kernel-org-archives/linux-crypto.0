From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/6] crypto: marvell: use memcpy_fromio()/memcpy_toio()
Date: Tue, 20 Oct 2015 08:58:52 +0100
Message-ID: <20151020075852.GT32532@n2100.arm.linux.org.uk>
References: <20151018173039.GA9737@n2100.arm.linux.org.uk>
 <E1Znrnf-00064N-OS@rmk-PC.arm.linux.org.uk>
 <87oafucudc.fsf@natisbad.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:49707 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbbJTH7N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2015 03:59:13 -0400
Content-Disposition: inline
In-Reply-To: <87oafucudc.fsf@natisbad.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 20, 2015 at 01:26:55AM +0200, Arnaud Ebalard wrote:
> Hi Russell,
> 
> Russell King <rmk+kernel@arm.linux.org.uk> writes:
> 
> > Use the IO memcpy() functions when copying from/to MMIO memory.
> > These locations were found via sparse.
> 
> On recent MVEBU hardware, *_std_* function are not expected to be used
> because we will instead use the TDMA-based versions. So the only
> possible penalty we could get (if any) from this change on recent
> devices is for the copy of the IV in mv_cesa_ablkcipher_process(). Out
> of curiosity, I took a quick look at what is generated and it seems this
> results in a call to mmiocpy(): 
> 
> 00000340 <mv_cesa_ablkcipher_process>:
>      340:       e1a0c00d        mov     ip, sp
>      344:       e92dd830        push    {r4, r5, fp, ip, lr, pc}
>      348:       e24cb004        sub     fp, ip, #4
>      34c:       e24dd008        sub     sp, sp, #8
> 
>      ....
> 
>      3a4:       e5943010        ldr     r3, [r4, #16]
>      3a8:       e5951008        ldr     r1, [r5, #8]
>      3ac:       e594001c        ldr     r0, [r4, #28]
>      3b0:       e2811040        add     r1, r1, #64     ; 0x40
>      3b4:       e593201c        ldr     r2, [r3, #28]
>      3b8:       ebfffffe        bl      0 <mmiocpy>
> 
> which if I am not mistaken is provided by arch/arm/lib/memcpy.S via:
> 
> ENTRY(mmiocpy)
> ENTRY(memcpy)
> 
> #include "copy_template.S"
> 
> ENDPROC(memcpy)
> ENDPROC(mmiocpy)
> 
> Am I right in concluding this will end up being the code of a usual
> memcpy(), i.e. the change is a noop in the final code compared to
> previous version? 

Almost - what's different is the compiler is not allowed to "optimise"
this memcpy call.  See 1bd46782d08b ("ARM: avoid unwanted GCC
memset()/memcpy() optimisations for IO variants")

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
