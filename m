Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A18C10F27
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 07:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADE992468F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 07:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583824190;
	bh=L11SdzzQTyUNNRxclnarGF3ZTYF1cI+qdg4ZV5PcXDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ilBjUnLBTxSRetfEPCx2aEGW+rpbkSQz/y0aE87wVP2TeLy/wheZfYGCYpHXQpely
	 vlG9cLnA/IelS6pKwzg93QmE3vnghfREUE1YupqygDMWAub2lyvqodFoU0Xa2FkB1W
	 TzrQwvm/0Gwk9brpxF688cuqKhxUuXGZyX4GhTG4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJHJr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 03:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgCJHJr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 03:09:47 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D79824677;
        Tue, 10 Mar 2020 07:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583824186;
        bh=L11SdzzQTyUNNRxclnarGF3ZTYF1cI+qdg4ZV5PcXDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lktXBtD6NO4hhBukLkC1l8I8yzsKD/dc7CaQMdMGMOzA4WGkwh1vxYWNAdBOX6pdL
         rpE4An+4S7gMURXu7b5U8rg3/FeD4IFeAJ2PZQ/I9BXgyGsGrr4HZaIWpekUVEbRsx
         xZOjrneNU3I8yx18lXvfWSMZSbOzyMRkkYLoJEvk=
Date:   Tue, 10 Mar 2020 15:09:40 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Anson Huang <Anson.Huang@nxp.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: imx8mp: add crypto node
Message-ID: <20200310070939.GD17772@dragon>
References: <20200224125023.29780-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200224125023.29780-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 24, 2020 at 02:50:23PM +0200, Horia Geantă wrote:
> Add node for CAAM - Cryptographic Acceleration and Assurance Module.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Applied, thanks.
