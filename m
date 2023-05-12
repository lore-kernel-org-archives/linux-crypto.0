Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7A6C77B7F
	for <linux-crypto@archiver.kernel.org>; Fri, 12 May 2023 11:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbjELLkD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 May 2023 07:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240230AbjELLkC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2023 07:40:02 -0400
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3ABFA;
        Fri, 12 May 2023 04:40:01 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 1D9DF40A6F; Fri, 12 May 2023 12:40:00 +0100 (BST)
Date:   Fri, 12 May 2023 12:40:00 +0100
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
Subject: Re: [PATCH v6 11/14] reboot: Secure Launch SEXIT support on reboot
 paths
Message-ID: <20230512114000.GG14461@srcf.ucam.org>
References: <20230504145023.835096-1-ross.philipson@oracle.com>
 <20230504145023.835096-12-ross.philipson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504145023.835096-12-ross.philipson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 04, 2023 at 02:50:20PM +0000, Ross Philipson wrote:
> If the MLE kernel is being powered off, rebooted or halted,
> then SEXIT must be called. Note that the SEXIT GETSEC leaf
> can only be called after a machine_shutdown() has been done on
> these paths. The machine_shutdown() is not called on a few paths
> like when poweroff action does not have a poweroff callback (into
> ACPI code) or when an emergency reset is done. In these cases,
> just the TXT registers are finalized but SEXIT is skipped.

What are the consequences of SEXIT not being called, and why is it ok to 
skip it in these circumstances?
