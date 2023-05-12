Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB28C77B7F
	for <linux-crypto@archiver.kernel.org>; Fri, 12 May 2023 11:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbjELLnz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 May 2023 07:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbjELLnx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2023 07:43:53 -0400
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40E24C3D;
        Fri, 12 May 2023 04:43:50 -0700 (PDT)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 77AB940A6F; Fri, 12 May 2023 12:43:49 +0100 (BST)
Date:   Fri, 12 May 2023 12:43:49 +0100
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
Subject: Re: [PATCH v6 13/14] tpm: Allow locality 2 to be set when
 initializing the TPM for Secure Launch
Message-ID: <20230512114349.GH14461@srcf.ucam.org>
References: <20230504145023.835096-1-ross.philipson@oracle.com>
 <20230504145023.835096-14-ross.philipson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504145023.835096-14-ross.philipson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 04, 2023 at 02:50:22PM +0000, Ross Philipson wrote:
> The Secure Launch MLE environment uses PCRs that are only accessible from
> the DRTM locality 2. By default the TPM drivers always initialize the
> locality to 0. When a Secure Launch is in progress, initialize the
> locality to 2.

This looks correct in itself, but looking at the CRB driver code I don't 
think locality support is actually implemented. Are there any SL systems 
using CRB?
