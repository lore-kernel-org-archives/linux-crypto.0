Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92016C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 19:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68E25208CA
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558983974;
	bh=lraj2dgvhVGkENZ+SetPaacf8Hlq5WoOdtIC/alYObk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GtJBOG3VCnAiAE7LZ/e2t+XfsJ8AXLOnoj15hH92S7bkOi/w9NP+1HQ6MgY1BiQdh
	 AZhYZVvA8B/DGHgJaiMpIWSpFQUYxt9l8vwBWgNNQCUT5ZJIznTXhmEuCVmsNE2a3a
	 Oh/p9KpMmLb4eDRyNoZzlY9kQslhqMp4ZKIlf2KU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfE0TGN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 15:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbfE0TGN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 15:06:13 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C58F20859;
        Mon, 27 May 2019 19:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558983972;
        bh=lraj2dgvhVGkENZ+SetPaacf8Hlq5WoOdtIC/alYObk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=scvVUhxvxhsmHivcsplQ6YzbNISOlG4+brRSjhTTzT9I/IRXSxAjPhTxNIfX+yn5M
         NgbKiKxOrUk65nGK/UcAhvxlHYhWMWLcKl9A8CSLJ73422fSbvxVqtCzGRUT6EHE7/
         4rnnyiAEmQXAt63x7u3iSy1+M2ZZmz1eEMQQaE78=
Date:   Mon, 27 May 2019 12:06:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
Subject: Re: [PATCH] crypto: xxhash - Implement xxhash support
Message-ID: <20190527190610.GB9394@sol.localdomain>
References: <20190527142810.31472-1-nborisov@suse.com>
 <20190527183932.GA9394@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527183932.GA9394@sol.localdomain>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 27, 2019 at 11:39:33AM -0700, Eric Biggers wrote:
> 
> Similarly, the 'out' array might be misaligned.  And conventionally the same
> bytes are output on all architectures.  So I suggest:
> 
> 	put_unaligned_u64(xxh64_digest(&ctx->xxhstate), out);
> 

I meant to write put_unaligned_le64.

- Eric
