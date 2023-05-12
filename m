Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC00C77B7C
	for <linux-crypto@archiver.kernel.org>; Fri, 12 May 2023 11:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbjELLE2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 May 2023 07:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240091AbjELLE0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2023 07:04:26 -0400
X-Greylist: delayed 252 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 May 2023 04:04:20 PDT
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB995BB7;
        Fri, 12 May 2023 04:04:19 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 3B95440A6F; Fri, 12 May 2023 11:47:53 +0100 (BST)
Date:   Fri, 12 May 2023 11:47:53 +0100
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
Subject: Re: [PATCH v6 02/14] Documentation/x86: Secure Launch kernel
 documentation
Message-ID: <20230512104753.GA14461@srcf.ucam.org>
References: <20230504145023.835096-1-ross.philipson@oracle.com>
 <20230504145023.835096-3-ross.philipson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504145023.835096-3-ross.philipson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 04, 2023 at 02:50:11PM +0000, Ross Philipson wrote:
> +Secure Launch does not interoperate with KASLR. If possible, the MLE should be
> +built with KASLR disabled::

Why does Secure Launch not interoperate with KASLR?

Re: IOMMUs

> +It is recommended that no other command line options should be set to override
> +the defaults above.

What happens if they are? Does doing so change the security posture of 
the system? If so, will the measurements be different in a way that 
demonstrates the system is in an insecure state?

