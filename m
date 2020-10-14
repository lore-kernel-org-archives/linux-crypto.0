Return-Path: <SRS0=tejW=DV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78B5C433E7
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Oct 2020 23:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB6A21D81
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Oct 2020 23:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602719713;
	bh=inl9rGGBsXiQj0KfmL/vEuhEcstZGazKvgv9Sglb54g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=k5ZS3vSVkHfdZ3A58xbqYIcG4+vvqBUuXS2FKKKi2E6+OOcwA22LqaZ5MsRQS5wqx
	 sSnfnGGnNGnYzgU8z3x6loQcnGq1kBZT++9TqDbOM0ZiBjPdk+B8WC84RMW49675D1
	 Iz92uwZS0qBAfnP3rojNNwWUeCaiaLHlb5YZXnsY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgJNXzM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Oct 2020 19:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgJNXzM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Oct 2020 19:55:12 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9A020704;
        Wed, 14 Oct 2020 23:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602719712;
        bh=inl9rGGBsXiQj0KfmL/vEuhEcstZGazKvgv9Sglb54g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gB0s1vVgtjlRBmb29SLqvcT+xk0sCUHmTbpC8/aZqKjYQVavPwWLktHjhrrbIQL2f
         GLKrasnvrxWfHTPLjMjl2DjN77pTsIKk1/bkul3rso/nMMXVedYz6MUdVM4GsWaaSU
         2MOjRrnq+eeIdF4sOhDirduYWRstCVO+ClNFXA5E=
Date:   Wed, 14 Oct 2020 16:55:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v7,net-next,03/13] octeontx2-af: add debugfs entries for
 CPT block
Message-ID: <20201014165510.47fa70b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012105719.12492-4-schalla@marvell.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-4-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Oct 2020 16:27:09 +0530 Srujana Challa wrote:
> +static ssize_t rvu_dbg_cpt_cmd_parser(struct file *filp,
> +				      const char __user *buffer, size_t count,
> +				      loff_t *ppos)
> +{
> +	struct seq_file *s = filp->private_data;
> +	struct rvu *rvu = s->private;
> +	char *cmd_buf;
> +	int ret = 0;
> +
> +	if ((*ppos != 0) || !count)
> +		return -EINVAL;
> +
> +	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
> +	if (!cmd_buf)
> +		return -ENOSPC;
> +
> +	if (parse_cpt_cmd_buffer(cmd_buf, &count, buffer,
> +				 rvu->rvu_dbg.cpt_ctx.e_type) < 0)
> +		ret = -EINVAL;
> +
> +	kfree(cmd_buf);
> +
> +	if (ret)
> +		return -EINVAL;
> +
> +	return count;
> +}

No command parsers in debugfs, please. 

Expose read only files for objects you want to be able to dump.
