Return-Path: <SRS0=zNo2=DW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A82BC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 00:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF43F21D7F
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 00:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602720387;
	bh=LF3ZguXmQXfWM7OBMb8/TELI/tiLww1IthxOUgyYamU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Lf7+C+t8gyWmY3tgHtTyE1451nBLRmNfOlIp89IqCK7vBj+sJZJ5cessCA8G2YQ5w
	 XrrF4kQYziw/j8YtJirzZxLBkrxQvlMMkflkSPff5gQ+SQyMko4C1b+9jKBuTkMpkh
	 59D41bdXeGLu7m0u9Myz8Oy1qxXAgHp6lXNlqpO0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgJOAGZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Oct 2020 20:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgJOAGZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Oct 2020 20:06:25 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D8C12173E;
        Thu, 15 Oct 2020 00:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602720384;
        bh=LF3ZguXmQXfWM7OBMb8/TELI/tiLww1IthxOUgyYamU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZxmM5XS9o7tPmtdV8eO5JJ7SO5JddD6FudPEm9YkRY5ocAMyW6b1DQ/kvE4oU9Xwj
         Vzla0FT2DjiXHd2v7eihrPRsahrF0ApU/XTV3Le1ED0zPRc5xYY3p/0L3WevomNhjR
         /8gClUxGe0FW4W938CF1YQUGv8+cdysZDXwBPWqQ=
Date:   Wed, 14 Oct 2020 17:06:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v7,net-next,07/13] crypto: octeontx2: load microcode and
 create engine groups
Message-ID: <20201014170622.6de93e9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012105719.12492-8-schalla@marvell.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-8-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Oct 2020 16:27:13 +0530 Srujana Challa wrote:
> +/* tar header as defined in POSIX 1003.1-1990. */
> +struct tar_hdr_t {
> +	char name[100];
> +	char mode[8];
> +	char uid[8];
> +	char gid[8];
> +	char size[12];
> +	char mtime[12];
> +	char chksum[8];
> +	char typeflag;
> +	char linkname[100];
> +	char magic[6];
> +	char version[2];
> +	char uname[32];
> +	char gname[32];
> +	char devmajor[8];
> +	char devminor[8];
> +	char prefix[155];
> +};
> +
> +struct tar_blk_t {
> +	union {
> +		struct tar_hdr_t hdr;
> +		char block[TAR_BLOCK_LEN];
> +	};
> +};

In networking we've been pushing back on parsing firmware files 
in the kernel. Why do you need to parse tar archives?
