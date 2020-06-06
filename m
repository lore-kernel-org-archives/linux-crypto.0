Return-Path: <SRS0=oTH+=7T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049E1C433DF
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Jun 2020 00:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93EB2076D
	for <linux-crypto@archiver.kernel.org>; Sat,  6 Jun 2020 00:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591403248;
	bh=QgCOXusovHurtH2iUvZjxOiDmAHQXSZYo61hmfFuCMY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=2Wi0qax03f0Rp+rqoN7UbHd67MrIITC5Yna6medsJEUIeY8ClsxUrLu8P84NKql/R
	 TJgLCLZmwPSO0o6+JbTQus2SkNRIWjZV97u/PB1TJG3Ss+hztmebXtE/7OTSwfGAUV
	 tex4642rKSfs4euEuhhUSRiOyeuw3ZcT8SO6QaRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgFFA11 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 20:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgFFA11 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 20:27:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E88D5206FA;
        Sat,  6 Jun 2020 00:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591403247;
        bh=QgCOXusovHurtH2iUvZjxOiDmAHQXSZYo61hmfFuCMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i08lCR32Af7XLiTxYUe7UwGXc5XNpY3QUgAlhdkkn5TfaaCRQ+HZNcsY1rnJwFsI4
         DAtuDuRS54Wy3TIwMc5bFNy71IRL0Azzt2QW85LLwMTrcA6myKeC0uHXFQy2i7Q83v
         QOMPhmR3GiFWtofa6ezvAv4Y9R+Zgqihr5KG8CG4=
Date:   Fri, 5 Jun 2020 17:27:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        pooja.trivedi@stackpath.com
Subject: Re: [PATCH net] net/tls(TLS_SW): Add selftest for 'chunked'
 sendfile test
Message-ID: <20200605172725.71d65c78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1591372878-10314-1-git-send-email-pooja.trivedi@stackpath.com>
References: <1591372878-10314-1-git-send-email-pooja.trivedi@stackpath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri,  5 Jun 2020 16:01:18 +0000 Pooja Trivedi wrote:
> This selftest tests for cases where sendfile's 'count'
> parameter is provided with a size greater than the intended
> file size.
> 
> Motivation: When sendfile is provided with 'count' parameter
> value that is greater than the size of the file, kTLS example
> fails to send the file correctly. Last chunk of the file is
> not sent, and the data integrity is compromised.
> The reason is that the last chunk has MSG_MORE flag set
> because of which it gets added to pending records, but is
> not pushed.
> Note that if user space were to send SSL_shutdown control
> message, pending records would get flushed and the issue
> would not happen. So a shutdown control message following
> sendfile can mask the issue.
> 
> Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
> Signed-off-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
> Signed-off-by: Josh Tway <josh.tway@stackpath.com>

Looks good to me, but I'm not 100% sure we want to merge it before 
the fix is merged.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
