Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B169BC7EE26
	for <linux-crypto@archiver.kernel.org>; Tue, 16 May 2023 01:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjEPBnQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 21:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjEPBnP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 21:43:15 -0400
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123BD5B9B;
        Mon, 15 May 2023 18:43:12 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 801BD42529; Tue, 16 May 2023 02:43:10 +0100 (BST)
Date:   Tue, 16 May 2023 02:43:10 +0100
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     "Daniel P. Smith" <dpsmith@apertussolutions.com>
Cc:     Ross Philipson <ross.philipson@oracle.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, linux-efi@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        ardb@kernel.org, James.Bottomley@hansenpartnership.com,
        luto@amacapital.net, nivedita@alum.mit.edu,
        kanth.ghatraju@oracle.com, trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v6 04/14] x86: Secure Launch Resource Table header file
Message-ID: <20230516014310.GA5403@srcf.ucam.org>
References: <20230504145023.835096-1-ross.philipson@oracle.com>
 <20230504145023.835096-5-ross.philipson@oracle.com>
 <20230512105554.GB14461@srcf.ucam.org>
 <30d5891d-4747-8d67-2667-ff07628740bd@apertussolutions.com>
 <20230515212206.GA2162@srcf.ucam.org>
 <df9d1260-41dd-034b-9dc6-14173c6c0d25@apertussolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9d1260-41dd-034b-9dc6-14173c6c0d25@apertussolutions.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 15, 2023 at 08:41:00PM -0400, Daniel P. Smith wrote:
> On 5/15/23 17:22, Matthew Garrett wrote:
> > What if I don't use grub, but use something that behaves equivalently?
> > Which value should be used here?
> 
> Generally we would request that the bootloader submit a request to register
> for a value to be reserved in the spec. That aside, the intent here is to
> allow for the possibility for the DLE handler to be independent from the
> bootloader, but this does not have to be this way. If a non-open entity
> decides to produce their own implementation, they can freely use a
> unallocated value at their own risk that it could be allocated to another
> bootloader in the future. Though in this scenario it likely would not matter
> as the non-open DLE handler would only be present when the non-open
> bootloader was present.

Is the expectation that the DLE will always be shipped with the 
bootloader? I think I'm not entirely clear on what's consuming this and 
why.

