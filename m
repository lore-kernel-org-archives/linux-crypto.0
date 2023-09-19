Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C277CD5488
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Sep 2023 07:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjISHjI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Sep 2023 03:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjISHio (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Sep 2023 03:38:44 -0400
X-Greylist: delayed 484 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Sep 2023 00:38:37 PDT
Received: from mail.leeswilly.pl (mail.leeswilly.pl [89.116.26.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32788125
        for <linux-crypto@vger.kernel.org>; Tue, 19 Sep 2023 00:38:37 -0700 (PDT)
Received: by mail.leeswilly.pl (Postfix, from userid 1001)
        id 614D3761319; Tue, 19 Sep 2023 09:30:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leeswilly.pl; s=mail;
        t=1695108632; bh=qCQG4c3C0tvkuSSy6okg6Td4OKi9mrw7rI9pE9SwJ9g=;
        h=Date:From:To:Subject:From;
        b=vGbXXPE0z6GJ8Mt/mzi/oIJUO9uZPYL/PBt99znR4X5rATmHP+Zh28i87jALHkMHT
         h9yPn2t2bwNAthVo2Gesl11Jbxoaj4QGBWeVhNx6O4BaXClnb44f8gxzilyvHYb48w
         emg9fd7E/eqwWau6pyTXk81YpztSizfMZC39QNdLYOW1cMlSnkoxS0IqRO5UBkP2SV
         GFDXLvZtYAJmewtpXhH0wOat/3tbRU3wUIBiO1iiw2Hu6sSwL1iKhW7ZMCxW63KX4j
         MoUb+loe8OlX1zJbVgt35eYhNWKrYHNFGS9HJcDrel8UQTeYp4gVyxm4sj9YyP68nT
         atx25VX3YEYXw==
Received: by mail.leeswilly.pl for <linux-crypto@vger.kernel.org>; Tue, 19 Sep 2023 07:30:18 GMT
Message-ID: <20230919084500-0.1.3z.bbhx.0.9vq77437gv@leeswilly.pl>
Date:   Tue, 19 Sep 2023 07:30:18 GMT
From:   "Jakub Lemczak" <jakub.lemczak@leeswilly.pl>
To:     <linux-crypto@vger.kernel.org>
Subject: =?UTF-8?Q?Pytanie_o_samoch=C3=B3d?=
X-Mailer: mail.leeswilly.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Dzie=C5=84 dobry,

Czy interesuje Pa=C5=84stwa rozwi=C4=85zanie umo=C5=BCliwiaj=C4=85ce moni=
torowanie samochod=C3=B3w firmowych oraz optymalizacj=C4=99 koszt=C3=B3w =
ich utrzymania?=20


Pozdrawiam
Jakub Lemczak
