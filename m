Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26143C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 16:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbiGYQnQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbiGYQnP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 12:43:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B7942ACC
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 09:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658767392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UHNxNqlIFS6FiMHcz8dYuGwwK68wQnJ9x3A5UD/5LTk=;
        b=DgnOguTkx5FjLvTuZ4RRhECEvWj7DjenP2+yv2vs6Tv5NqI5swdU6K/2azB8kBArS4Vihh
        ns1EriNkP1mwrKvKyr+HUEqa2lEetaC6OgK9yyroIHs2ySynaWbXuXHT0rvJ8nkxxZpDBe
        79pUEVQdigTTgJ3/RvPo6naTrOe+riM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-aict4gFDNvOzbxEClJ62WQ-1; Mon, 25 Jul 2022 12:43:09 -0400
X-MC-Unique: aict4gFDNvOzbxEClJ62WQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAD02299E74E;
        Mon, 25 Jul 2022 16:43:08 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65685C15D67;
        Mon, 25 Jul 2022 16:43:07 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Rich Felker <dalias@libc.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>,
        linux-crypto@vger.kernel.org, Michael@phoronix.com
Subject: Re: arc4random - are you sure we want these?
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
        <87bktdsdrk.fsf@oldenburg.str.redhat.com> <Yt54x7uWnsL3eZSx@zx2c4.com>
        <87v8rlqscj.fsf@oldenburg.str.redhat.com> <Yt6eHfnlEN8ViWrA@zx2c4.com>
        <20220725160652.GG7074@brightrain.aerifal.cx>
Date:   Mon, 25 Jul 2022 18:43:05 +0200
In-Reply-To: <20220725160652.GG7074@brightrain.aerifal.cx> (Rich Felker's
        message of "Mon, 25 Jul 2022 12:06:53 -0400")
Message-ID: <874jz5p2hy.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Rich Felker:

> AT_RANDOM is unusable as a fallback here because it's equivalent to
> GRND_INSECURE. It's silently broken at early boot time. In musl we're
> likely going to end up using the legacy SYS_sysctl on pre-getrandom
> kernels even though it spammed syslog just because it seems to be the
> only way to get blocking secure entropy on those kernels.

Even pre-getrandom, sysctl was rarely enabled in kernel configurations
if I recall correctly.  I doubt it is an option to avoid process
termination with old kernels/seccomp filters.

Thanks,
Florian

