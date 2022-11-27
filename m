Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED429C46467
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Nov 2022 21:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiK0VMr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Nov 2022 16:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiK0VMq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Nov 2022 16:12:46 -0500
X-Greylist: delayed 244 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Nov 2022 13:12:45 PST
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE59BC86;
        Sun, 27 Nov 2022 13:12:45 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 3317D424A3; Sun, 27 Nov 2022 21:12:44 +0000 (GMT)
Date:   Sun, 27 Nov 2022 21:12:44 +0000
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-efi@vger.kernel.org, linux-crypto@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        ardb@kernel.org
Subject: Re: [PATCH v3 2/5] efi: stub: use random seed from EFI variable
Message-ID: <20221127211244.GB32253@srcf.ucam.org>
References: <20221122020404.3476063-1-Jason@zx2c4.com>
 <20221122020404.3476063-3-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122020404.3476063-3-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 22, 2022 at 03:04:01AM +0100, Jason A. Donenfeld wrote:

> +		 * We delete the seed here, and /hope/ that this causes EFI to
> +		 * also zero out its representation on disk. This is somewhat

Several implementations I've worked with simply append a deletion marker 
or append a new variable value until the variable store fills up 
entirely, at which point a garbage collection event is either run or 
scheduled for the next reboot. The spec doesn't define how this is 
handled so unfortunately I don't think there's any way to get a pony 
here.
