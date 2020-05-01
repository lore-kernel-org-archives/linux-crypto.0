Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFF7C4724C
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 10:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB5E21924
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 10:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588329027;
	bh=fQoUER+hD9y0dxOn2+s1F57pQS832ty+/T7TTBnXYg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Py4zeDXSSMRRRYh7oLshLWH3N4tFU2NRVow+E/ZI6GK+lKif8IJHsZCVLI80fBe4E
	 gnezHyBA6XtQwy+3FzZZWj3AT+/r5lot7s6R3kIR1tCViAqBsVBDobnGa/dUw8T24W
	 BsGUkKK1YqqIqjHGOeGYLIS4H1CPTyvnmx7TgGnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgEAKa0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 May 2020 06:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgEAKa0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 May 2020 06:30:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DB982166E;
        Fri,  1 May 2020 10:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588329025;
        bh=fQoUER+hD9y0dxOn2+s1F57pQS832ty+/T7TTBnXYg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yWc3fcgoZs18quH7GDjt3uFZtIx942V5HtyFTkw2WkrkIApz1ZKJrRVI8ugAoepka
         kn24ULYNRR9ewf6nNWM6fhllYy+tYcwTytCeP4267edcN45z5e3ZKOqoUNHICJhNcD
         q0qRb3Bce6kGvGn7wppzpIN7rKpWgPf1dG/BrBAQ=
Date:   Fri, 1 May 2020 12:30:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rajan Vaja <rajan.vaja@xilinx.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        kalyani.akula@xilinx.com, michal.simek@xilinx.com,
        jolly.shah@xilinx.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH char-misc-next] crypto: xilinx: Handle AES PM API return
 status
Message-ID: <20200501103021.GA1416784@kroah.com>
References: <1588328091-16368-1-git-send-email-rajan.vaja@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588328091-16368-1-git-send-email-rajan.vaja@xilinx.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 01, 2020 at 03:14:51AM -0700, Rajan Vaja wrote:
> Fixes: bc86f9c54616 ("firmware: xilinx: Remove eemi ops for aes engine")
> 
> Return value of AES PM API is not handled which may result in
> unexpected value of "status" in zynqmp_pm_aes_engine().
> 
> Consider "status" value as valid only if AES PM API is successful.
> 
> Signed-off-by: Rajan Vaja <rajan.vaja@xilinx.com>

No "Reported-by:" line?

And put the "Fixes:" line down in the s-o-b area please.

thanks,

greg k-h
