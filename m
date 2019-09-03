Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF8EC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 18:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6B7E21897
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 18:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfICS6d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 14:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfICS6d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 14:58:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D34562A09B3;
        Tue,  3 Sep 2019 18:58:32 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEE6B1001B02;
        Tue,  3 Sep 2019 18:58:28 +0000 (UTC)
Date:   Tue, 3 Sep 2019 14:58:28 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v13 6/6] md: dm-crypt: omit parsing of the encapsulated
 cipher
Message-ID: <20190903185827.GD13472@redhat.com>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-7-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819141738.1231-7-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 03 Sep 2019 18:58:33 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 19 2019 at 10:17am -0400,
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Only the ESSIV IV generation mode used to use cc->cipher so it could
> instantiate the bare cipher used to encrypt the IV. However, this is
> now taken care of by the ESSIV template, and so no users of cc->cipher
> remain. So remove it altogether.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Might be wise to bump the dm-crypt target's version number (from
{1, 19, 0} to {1, 20, 0}) at the end of this patch too though...

But again, Herbert please feel free to pull this into your 5.4 branch.

Thanks,
Mike
