From: Stephan Mueller <smueller@chronox.de>
Subject: Re: akcipher use
Date: Sat, 27 Jun 2015 18:25:25 +0200
Message-ID: <1934055.of3DnBQRik@tachyon.chronox.de>
References: <1708764.x5PFhLSanv@tauon.atsec.com> <558C5444.4000105@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47865 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbbF0QZd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Jun 2015 12:25:33 -0400
In-Reply-To: <558C5444.4000105@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 25. Juni 2015, 12:19:32 schrieb Tadeusz Struk:

Hi Tadeusz,

> On 06/25/2015 04:58 AM, Stephan Mueller wrote:

> > 
> > - how would a hardware implementation offering only a hybrid asym cipher
> > implementation (i.e. a full signature mechanism or bulk data encryption
> > mechanism) be usable via that API?
> 
> Usually the HW offers acceleration for encryption primitives.
> To support the encryption schemes we can introduce templates for instance
> pkcs1_v15(rsa) or oaep(rsa) as it was proposed by Horia Geanta.

Ok, in this case, it would mean that rsa would point to the software 
implementation and oaep(rsa) would point to the hardware. Would I be correct?

> 
> > - currently I only see one user in the kernel for asym ciphers: the module
> > signing mechanism. Do you expect more to come? Or am I missing others?
> > 
> > - If no, then it sounds like that the akcipher API is a means to make asym
> > ciphers implemented in hardware and only accessible from supervisor state
> > available. I would assume that the majority of the users that may be
> > interested in that kind of support resides in user space. Is the intention
> > to develop an AF_ALG interface (note, I personally already thought about
> > that subject for some time now)?
> 
> Yes, that's the main use case for this. We want to be able to accelerate SSL
> handshakes.

Are you currently working on an AF_ALG interface?

-- 
Ciao
Stephan
