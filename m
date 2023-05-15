Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F1FC77B7D
	for <linux-crypto@archiver.kernel.org>; Mon, 15 May 2023 14:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239399AbjEOOPF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 10:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbjEOOPA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 10:15:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11AF19B0;
        Mon, 15 May 2023 07:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TJRlSPOnx9ii8Kt9hBjPHaiwxx3O1eu4ohGE4HeKKXc=; b=hdDoNo+TQguN63TdoZIaPhs9VJ
        IGBOWWflrw4xhBeHcCrd02GIfGDiVRJOLI2cw7LSHbhW45tn7ikjqdQkGz5kXXNQD+gGXpytwWMkT
        Lfl887HRTmMZI2kUGRahT9tiUlcJ+bwLKYke+MH2+loRsR0yoVvl7VEFjLeIPiL80FJs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pyYyW-00CtoW-Nm; Mon, 15 May 2023 16:14:56 +0200
Date:   Mon, 15 May 2023 16:14:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     FUJITA Tomonori <tomo@exabit.dev>
Cc:     rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: Re: [PATCH 2/2] rust: add socket support
Message-ID: <f22b24f8-f599-4eec-9535-bcca71138057@lunn.ch>
References: <20230515043353.2324288-1-tomo@exabit.dev>
 <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 15, 2023 at 04:34:28AM +0000, FUJITA Tomonori wrote:
> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
> 
> minimum abstraction for networking.

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   3 +
>  rust/kernel/lib.rs              |   2 +
>  rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++

The full networking API is huge. So trying to put it all into net.rs
is unlikely to work in the long run. Maybe it would be better to name
this file based on the tiny little bit of the network API you are
writing an abstraction for?

If i'm reading the code correctly, you are abstracting the in kernel
socket API for only TCP over IPv4. Probably with time that will get
extended to IPv6, and then UDP. So maybe call this net-kern-socket.rs?

	 Andrew
