Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3852C678DC
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 08:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbjHRIqo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 04:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358790AbjHRIqY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 04:46:24 -0400
X-Greylist: delayed 2238 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Aug 2023 01:46:23 PDT
Received: from mail.leachkin.pl (mail.leachkin.pl [217.61.97.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6978A3A94
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 01:46:23 -0700 (PDT)
Received: by mail.leachkin.pl (Postfix, from userid 1001)
        id 582A584617; Fri, 18 Aug 2023 09:06:45 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leachkin.pl; s=mail;
        t=1692346046; bh=elHzctRz/z3PfTIhGYJKd0TeBTmca98Y+JNgX4gfsPI=;
        h=Date:From:To:Subject:From;
        b=PYWB7KdDN/AFtrlYZ/MBcNv0QK6/MwOUpo+AqmX0tu8pTi+zKpPMXGMjpoJJ43mqD
         b7vuWppp7+FnMgFUJpA8ud2HEnz9vNqhcfRA2u4yW3KZOH4l2cbA+HBNoYnShRENc1
         lvqSFwilvONJNqABztHyyfvBIWrHlws+lAZOaa2geIrSc86S1KwHVver7NBmyb3Hqo
         uwoUGiYC44DUrdrIPeeEIGiWZc/UGvISe5c/jfc8E5AWWFO1KW+oQcTZOceL8JINSU
         XNpkmidOtDxtewSH5tMXlyGhH+j7F2AG/DZ/k9HFM2YLuhRaA429l3fIBMMQW42BfS
         dYvwYOTtXCq4g==
Received: by mail.leachkin.pl for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 08:06:01 GMT
Message-ID: <20230818074501-0.1.4u.cs7x.0.o7jsp246pg@leachkin.pl>
Date:   Fri, 18 Aug 2023 08:06:01 GMT
From:   "Jakub Lemczak" <jakub.lemczak@leachkin.pl>
To:     <linux-crypto@vger.kernel.org>
Subject: =?UTF-8?Q?Pytanie_o_samoch=C3=B3d?=
X-Mailer: mail.leachkin.pl
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


Pozdrawiam,
Jakub Lemczak
