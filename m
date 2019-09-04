Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EBCC3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 13:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 683192186A
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 13:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfIDNin (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 09:38:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730145AbfIDNim (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 09:38:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F31E109EFC7;
        Wed,  4 Sep 2019 13:38:42 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4753860166;
        Wed,  4 Sep 2019 13:38:37 +0000 (UTC)
Date:   Wed, 4 Sep 2019 09:38:36 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com
Subject: Re: [PATCH v13 6/6] md: dm-crypt: omit parsing of the encapsulated
 cipher
Message-ID: <20190904133836.GA17836@redhat.com>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-7-ard.biesheuvel@linaro.org>
 <20190903185827.GD13472@redhat.com>
 <403192f0-d1c4-0c60-5af1-7dee8516d629@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <403192f0-d1c4-0c60-5af1-7dee8516d629@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Wed, 04 Sep 2019 13:38:42 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 04 2019 at  7:01am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 03/09/2019 20:58, Mike Snitzer wrote:
> > On Mon, Aug 19 2019 at 10:17am -0400,
> > Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > 
> >> Only the ESSIV IV generation mode used to use cc->cipher so it could
> >> instantiate the bare cipher used to encrypt the IV. However, this is
> >> now taken care of by the ESSIV template, and so no users of cc->cipher
> >> remain. So remove it altogether.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > 
> > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > Might be wise to bump the dm-crypt target's version number (from
> > {1, 19, 0} to {1, 20, 0}) at the end of this patch too though...
> 
> The function should be exactly the same, dependencies on needed modules are set.
> 
> In cryptsetup we always report dm target + kernel version,
> so we know that since version 5.4 it uses crypto API for ESSIV.
> I think version bump here is really not so important.
> 
> Just my two cents :)

Yes, that's fine.. I staged it for 5.4 yesterday without the version bump.

Thanks,
Mike
