Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402C8C7EE2A
	for <linux-crypto@archiver.kernel.org>; Fri, 12 May 2023 11:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240716AbjELLE1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 May 2023 07:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240164AbjELLE0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2023 07:04:26 -0400
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20181720;
        Fri, 12 May 2023 04:04:21 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 39D4242527; Fri, 12 May 2023 11:55:54 +0100 (BST)
Date:   Fri, 12 May 2023 11:55:54 +0100
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Ross Philipson <ross.philipson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, linux-efi@vger.kernel.org,
        dpsmith@apertussolutions.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ardb@kernel.org,
        James.Bottomley@hansenpartnership.com, luto@amacapital.net,
        nivedita@alum.mit.edu, kanth.ghatraju@oracle.com,
        trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v6 04/14] x86: Secure Launch Resource Table header file
Message-ID: <20230512105554.GB14461@srcf.ucam.org>
References: <20230504145023.835096-1-ross.philipson@oracle.com>
 <20230504145023.835096-5-ross.philipson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504145023.835096-5-ross.philipson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 04, 2023 at 02:50:13PM +0000, Ross Philipson wrote:

> +#define SLR_TABLE_MAGIC		0x4452544d

From convention I'd expect this to be 0x534c5254, but not really an 
issue.

> +/* SLR defined bootloaders */
> +#define SLR_BOOTLOADER_INVALID	0
> +#define SLR_BOOTLOADER_GRUB	1

Oof. Having the kernel know about bootloaders has not worked out super 
well for us in the past. If someone writes a new bootloader, are they 
unable to Secure Launch any existing kernels? The pragmatic thing for 
them to do would be to just pretend they're grub, which kind of defeats 
the point of having this definition...

> +} __packed;

Random nit - why are they all packed? Are there circumstances where two 
pieces of code with different assumptions about alignment will be 
looking at a single instance of a table? It doesn't seem likely we're 
going to be doing DRTM in a 32-bit firmware environment while launching 
a 64-bit kernel?
