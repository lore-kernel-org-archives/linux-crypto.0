Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE07C7EE26
	for <linux-crypto@archiver.kernel.org>; Sun, 14 May 2023 19:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjENTL6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 May 2023 15:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjENTL5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 May 2023 15:11:57 -0400
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093A61984;
        Sun, 14 May 2023 12:11:53 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 9869140A84; Sun, 14 May 2023 20:11:50 +0100 (BST)
Date:   Sun, 14 May 2023 20:11:50 +0100
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ross Philipson <ross.philipson@oracle.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, linux-efi@vger.kernel.org,
        dpsmith@apertussolutions.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, James.Bottomley@hansenpartnership.com,
        luto@amacapital.net, nivedita@alum.mit.edu,
        kanth.ghatraju@oracle.com, trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v6 06/14] x86: Add early SHA support for Secure Launch
 early measurements
Message-ID: <20230514191150.GA17168@srcf.ucam.org>
References: <20230504145023.835096-1-ross.philipson@oracle.com>
 <20230504145023.835096-7-ross.philipson@oracle.com>
 <20230510012144.GA1851@quark.localdomain>
 <20230512110455.GD14461@srcf.ucam.org>
 <CAMj1kXE8m5jCH3vW54ys=dE2-Vf_gnnueR6_g4Rq-LSJ5BqRjA@mail.gmail.com>
 <20230512112847.GF14461@srcf.ucam.org>
 <CAMj1kXFUDUbH4avVs37uLkS=BfSFB1F60e5Ei5_m2aWxOYOGPw@mail.gmail.com>
 <4acf414e-67e7-c964-566b-a5e657e9d1bb@citrix.com>
 <20230514181817.GA9528@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230514181817.GA9528@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, May 14, 2023 at 11:18:17AM -0700, Eric Biggers wrote:
> On Fri, May 12, 2023 at 01:24:22PM +0100, Andrew Cooper wrote:
> > You're suggesting that because Linux has been slow to take D-RTM over
> > the past decade, you're going to intentionally break people with older
> > hardware just because you don't feel like using an older algorithm?
> > 
> > That's about the worst possible reason to not take support.
> > 
> > There really are people in the world with older TPM 1.2 systems where
> > this D-RTM using SHA1 only is an improvement over using the incumbent tboot.
> > 
> > ~Andrew
> 
> This patchset is proposing a new kernel feature.  So by definition, there are no
> existing users of it that can be broken.

The patchset reimplements a more extensible version of an existing 
feature which people already consume, and presumably people will be 
encouraged to transition to it. There is plenty of hardware that 
supports this feature that only implements SHA-1. If you want to propose 
that the kernel not implement any functionality that uses deprecated 
hash algorithms then that seems like a larger conversation rather than 
one that should focus on a single pachset.
