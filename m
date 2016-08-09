From: Stephan Mueller <smueller@chronox.de>
Subject: Re: RSA key size not allowed in FIPS
Date: Tue, 09 Aug 2016 18:08:46 +0200
Message-ID: <1501962.KnUvgEXWzo@tauon.atsec.com>
References: <D3CF4E8C.2883%tsarangi@trustwave.com> <D3CF597F.289B%tsarangi@trustwave.com> <D3CF6958.28A9%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "dhowells@redhat.com" <dhowells@redhat.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34408 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbcHIQIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 12:08:49 -0400
In-Reply-To: <D3CF6958.28A9%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 16:07:06 CEST schrieb Tapas Sarangi:

Hi Tapas,

> Hi Stephan,
> 
> 
> Thanks for your responses. I am past this error now.
> 
> I am still NOT out of trouble. Now, test integrity fails while trying to
> get into FIPS mode. Here is the snippet of error messages.  I will create
> a separate thread for this,
> 
> /boot/vmlinuz-4.7.0-1.tos2_5: OK
> modprobe: ERROR: could not insert 'drbg': Unknown symbol in module, or
> unknown parameter (see dmesg)

Do you see which symbol is missing?


> [    1.193406] dracut: FATAL: FIPS integrity test failed
> [    1.194086] dracut: Refusing to continue
> 
> [    1.195820] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x00000100
> [    1.195820]
> 
> 
> -Tapas
> 
> 
> 
> On 8/9/16, 10:00 AM, "Tapas Sarangi" <TSarangi@trustwave.com> wrote:
> 
> 
> >Embarrassing! Yes, I just saw this while you are pressing send on that
> >replyŠ default bits were set to 4096 in x509.genkey. :-(
> >
> >I am trying out with 2048 bits. I will confirm.
> >
> >-Tapas
> >
> >
> >On 8/9/16, 9:55 AM, "Stephan Mueller" <smueller@chronox.de> wrote:
> >
> >
> >>Am Dienstag, 9. August 2016, 14:39:03 CEST schrieb Tapas Sarangi:
> >>
> >>Hi Tapas, David,
> >>
> >>
> >>> Hi Stephan,
> >>>
> >>>
> >>>
> >>> If I understand this correctly, this (CONFIG_MODULE_SIG_HASH=³sha256")
> >>> tells about the key size used.
> >>> I am using ³sha256². Initially, I was using ³sha512² which I thought
> >>>
> >>>could
> >>>
> >>> be causing problem, but I am getting same error when change it to
> >>> ³sha256².
> >>>
> >>>
> >>>
> >>> [root@localhost ~]# grep MODULE_SIG /boot/config-4.7.0-1.tos2_5
> >>>
> >>>
> >>>
> >>> CONFIG_MODULE_SIG=y
> >>> # CONFIG_MODULE_SIG_FORCE is not set
> >>> CONFIG_MODULE_SIG_ALL=y
> >>> # CONFIG_MODULE_SIG_SHA1 is not set
> >>> # CONFIG_MODULE_SIG_SHA224 is not set
> >>> CONFIG_MODULE_SIG_SHA256=y
> >>> # CONFIG_MODULE_SIG_SHA384 is not set
> >>> # CONFIG_MODULE_SIG_SHA512 is not set
> >>> CONFIG_MODULE_SIG_HASH="sha256"
> >>> CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
> >>
> >>
> >>It is rather the question how signing_key.pem is generated.
> >>
> >>Do you have the file certs/x509.genkey? If yes, what is the default_bits
> >>value?
> >>
> >>David, the x509.genkey file seems to generate a 4k RSA key per default.
> >>This
> >>will cause a panic with fips=1 as only 2k and 3k keys are allowed.
> >>
> >>Ciao
> >>Stephan
> >
> >
> 
> 
> 
> ________________________________
> 
> This transmission may contain information that is privileged, confidential,
> and/or exempt from disclosure under applicable law. If you are not the
> intended recipient, you are hereby notified that any disclosure, copying,
> distribution, or use of the information contained herein (including any
> reliance thereon) is strictly prohibited. If you received this transmission
> in error, please immediately contact the sender and destroy the material in
> its entirety, whether in electronic or hard copy format.



Ciao
Stephan
