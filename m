Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD255C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 11:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F4B2078D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 11:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591874604;
	bh=yiSKRpPE0yOcjH3qcZl0yl+bP6wtHGpz5GoZ0ATi6Q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=upnYKsGhls2eB2ulFrHyhimpUkmg/eDF9OArNJv2wqK8KanxS0r3cD0en/he8fxCm
	 hl8daE/oaZWg+MFWPd/OouzDNJ+WNggQ7z3dhS4EhG+Tu3JylOwHceQHh/6O7gDVi1
	 B1/4ci/+yDWdaeTbF6n1oUi/6UQLiTt2pIiWej1E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgFKLXV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 07:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbgFKLXT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 07:23:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E43B2078D;
        Thu, 11 Jun 2020 11:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591874598;
        bh=yiSKRpPE0yOcjH3qcZl0yl+bP6wtHGpz5GoZ0ATi6Q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YDnHAsjrr+xzEZPsAyVakm0PBtlUURtCNF1YKUQn/DFT6p2oaVucuMJl8bG2tt5p9
         rmNhLHDKHpjOHsAVhHpqhB8qhh4VaAfrHJb3UIqdnr8HCWbkE7NmI8GTdqyfR1fhKy
         SLYBbfW0xX4SCz2Vy+8YLZwQxmTz8JQOmJiSIAv0=
Date:   Thu, 11 Jun 2020 13:23:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Su Kang Yin <cantona@cantona.net>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: talitos - fix ECB and CBC algs ivsize
Message-ID: <20200611112312.GB342390@kroah.com>
References: <cantona@cantona.net>
 <20200611100745.6513-1-cantona@cantona.net>
 <718354b4-d284-8e47-4085-f45101f9ca36@csgroup.eu>
 <20200611110350.GA3954279@kroah.com>
 <24a06073-1765-985e-029b-80a78ad02b89@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24a06073-1765-985e-029b-80a78ad02b89@csgroup.eu>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 11, 2020 at 01:09:38PM +0200, Christophe Leroy wrote:
> 
> 
> Le 11/06/2020 à 13:03, Greg KH a écrit :
> > On Thu, Jun 11, 2020 at 12:50:24PM +0200, Christophe Leroy wrote:
> > > Hi,
> > > 
> > > Le 11/06/2020 à 12:07, Su Kang Yin a écrit :
> > > > Patch for 4.9 upstream:
> > > > 
> > > > commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> > > > wrongly modified CBC algs ivsize instead of ECB aggs ivsize.
> > > 
> > > To make it clear and avoid this problem to happen again, please generate
> > > your patch with option -U8
> > 
> > No need, this patch should be fine as-is.
> > 
> 
> Still, this patch includes more than the original patch as far as I can see
> (scroll down and see other comments in that answer)

Ah, good catch, I'll go drop this now, thanks!

greg k-h
