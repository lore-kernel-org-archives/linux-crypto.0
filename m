Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C92FC77B76
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Apr 2023 12:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjDYMC2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Apr 2023 08:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbjDYMC1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2023 08:02:27 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B95F4C0C;
        Tue, 25 Apr 2023 05:02:24 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Q5LGL5LpBz4xFh;
        Tue, 25 Apr 2023 22:02:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1682424139;
        bh=rH8304UzqliqdTTNowtCqG5UFDD8oj/c7YMTXxFApSA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=B/AvhVrrpcUYzRgq0Q3x/7YLgVsVSqkIBfwT0x5l7H/4xYfG/JpEVEHsQafVMKlQe
         JpomzP4KwlTR11vBdAzCNE0KV4C9jvVn9t7CNRYNqf+EaBgZ+THpT0Db/opqR6S/Yp
         rpTRJLPUlI5hUljD9iP/y3dZKAiq3TwUW83MWh/d9RNP6tGvlIuQME9KlogUfZHaWf
         gObSVb8nLLC7xm/NpP1ktG/qX8caZameK4EjGph7m+Q5yd5utydiKaNhfrrHiRd4Tp
         aVYOs8D35k8eaqmtKnsp9EP1NRDfb6OR0DJKwBlSFaOnedkTh9x8Ssy/n4rPfKvDxA
         cVZQrrxN4vb9w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Danny Tsen <dtsen@linux.ibm.com>,
        "Elliott, Robert (Servers)" <elliott@hpe.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "leitao@debian.org" <leitao@debian.org>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "appro@cryptogams.org" <appro@cryptogams.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "ltcgcw@linux.vnet.ibm.com" <ltcgcw@linux.vnet.ibm.com>,
        "dtsen@us.ibm.com" <dtsen@us.ibm.com>
Subject: Re: [PATCH 1/5] An optimized Chacha20 implementation with 8-way
 unrolling for ppc64le.
In-Reply-To: <a8239d13-a3ee-d6c6-13c5-7f668991489d@linux.ibm.com>
References: <20230424184726.2091-1-dtsen@linux.ibm.com>
 <20230424184726.2091-2-dtsen@linux.ibm.com>
 <MW5PR84MB1842E9D9F596D3928B415DBAAB679@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <a8239d13-a3ee-d6c6-13c5-7f668991489d@linux.ibm.com>
Date:   Tue, 25 Apr 2023 22:02:16 +1000
Message-ID: <87a5ywyxtj.fsf@mail.concordia>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Danny Tsen <dtsen@linux.ibm.com> writes:
> This is recommended template to use for IBM copyright.

According to who?

The documentation I've seen specifies "IBM Corp." or "IBM Corporation".

cheers
