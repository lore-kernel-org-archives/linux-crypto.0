Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD041C12002
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 08:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A540C613E9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 08:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbhGSIRS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 04:17:18 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:30871 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235313AbhGSIRS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 04:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626684715;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dWok9o8gQ6+5Ip4xo7b/xcJ8eJ4EHeLf0PW7SYuRJ2s=;
    b=Q+nuYqZBAwl1KFY4p3jYxN7prLCv4zwXwpXwyrrrs4Rh7GK8DeeMXk5lNboUnwHyPZ
    RQX75tPCTbRhoYcGsZf0Vacg7W2CnhXza9i9OSf5hbZdQNibHMh8Ua2GN4JtqM3+4Tuy
    jtHWfR2qjv14pkcPHU7IwpxJhMSzlmzSJXPz4iOlLgnDI7w8TA9KOTStJrRGjAsZCx52
    dLwUsW8KtGATK4xcKxetS6xPks13xEIzDqaSC9L+mkAVB1hjoq6QjYlSyOdftRy7zs0p
    7uSrHc/BG35Za1uAen39capZixR+LYa9rohTT4OoIG2JhTDaGEkp+EG01rPThRqtMuZe
    QJ1A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSlBkMRYMkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id 9043bbx6J8prGyn
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 19 Jul 2021 10:51:53 +0200 (CEST)
Message-ID: <463a191b9896dd708015645cfc125988cd5deaef.camel@chronox.de>
Subject: Re: [PATCH 09/11] nvmet: Implement basic In-Band Authentication
From:   Stephan Mueller <smueller@chronox.de>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Date:   Mon, 19 Jul 2021 10:51:53 +0200
In-Reply-To: <59695981-9edc-6b7a-480a-94cca95a0b8c@suse.de>
References: <20210716110428.9727-1-hare@suse.de>
         <2510347.locV8n3378@positron.chronox.de>
         <a4d4bda0-2bc8-0d0c-3e81-55adecd6ce52@suse.de>
         <6538288.aohFRl0Q45@positron.chronox.de>
         <59695981-9edc-6b7a-480a-94cca95a0b8c@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, dem 19.07.2021 um 10:15 +0200 schrieb Hannes Reinecke:
> On 7/18/21 2:56 PM, Stephan Müller wrote:
> > Am Sonntag, 18. Juli 2021, 14:37:34 CEST schrieb Hannes Reinecke:

> > > The key is also used when using the ffdhe algorithm.
> > > Note: I _think_ that I need to use this key for the ffdhe algorithm,
> > > because the implementation I came up with is essentially plain DH with
> > > pre-defined 'p', 'q' and 'g' values. But the DH implementation also
> > > requires a 'key', and for that I'm using this key here.
> > > 
> > > It might be that I'm completely off, and don't need to use a key for our
> > > DH implementation. In that case you are correct.
> > > (And that's why I said I'll need a review of the FFDHE implementation).
> > > But for now I'll need the key for FFDHE.
> > 
> > Do I understand you correctly that the dhchap_key is used as the input to
> > the 
> > DH - i.e. it is the remote public key then? It looks strange that this is
> > used 
> > for DH but then it is changed here by hashing it together with something
> > else 
> > to form a new dhchap_key. Maybe that is what the protocol says. But it
> > sounds 
> > strange to me, especially when you think that dhchap_key would be, say,
> > 2048 
> > bits if it is truly the remote public key and then after the hashing it is
> > 256 
> > this dhchap_key cannot be used for FFC-DH.
> > 
> > Or are you using the dhchap_key for two different purposes?
> > 
> > It seems I miss something here.
> > 
> No, not entirely. It's me who buggered it up.
> I got carried away by the fact that there is a crypto_dh_encode_key()
> function, and thought I need to use it here.

Thank you for clarifying that. It sounds to me that there is no defined
protocol (or if there, I would be wondering how the code would have worked
with a different implementation). Would it make sense to first specify a
protocol for authentication and have it discussed? I personally think it is a
bit difficult to fully understand the protocol from the code and discuss
protocol-level items based on the code.

Thanks
Stephan

