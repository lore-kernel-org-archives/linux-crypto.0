Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC59C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jun 2022 10:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241638AbiFGKrP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jun 2022 06:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241657AbiFGKqi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jun 2022 06:46:38 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22457EFF0C
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 03:46:18 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4A8DA67373; Tue,  7 Jun 2022 12:46:15 +0200 (CEST)
Date:   Tue, 7 Jun 2022 12:46:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
Message-ID: <20220607104614.GB25515@lst.de>
References: <20220518112234.24264-1-hare@suse.de> <20220518112234.24264-10-hare@suse.de> <e13a0c12-362d-e4b6-c558-03367815264b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e13a0c12-362d-e4b6-c558-03367815264b@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, May 22, 2022 at 02:44:23PM +0300, Max Gurtovoy wrote:
>> +#include "nvmet.h"
>> +#include "../host/auth.h"
>
> maybe we can put the common stuff to include/linux/nvme-auth.h instead of 
> doing ../host/auth.h ?

Agreed.
