Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C717C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 18:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE4221897
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 18:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfICSzm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 14:55:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfICSzm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 14:55:42 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 60D3C86E86F;
        Tue,  3 Sep 2019 18:55:42 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 69A321001B13;
        Tue,  3 Sep 2019 18:55:38 +0000 (UTC)
Date:   Tue, 3 Sep 2019 14:55:37 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v13 5/6] md: dm-crypt: switch to ESSIV crypto API template
Message-ID: <20190903185537.GC13472@redhat.com>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-6-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819141738.1231-6-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 03 Sep 2019 18:55:42 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 19 2019 at 10:17am -0400,
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Replace the explicit ESSIV handling in the dm-crypt driver with calls
> into the crypto API, which now possesses the capability to perform
> this processing within the crypto subsystem.
> 
> Note that we reorder the AEAD cipher_api string parsing with the TFM
> instantiation: this is needed because cipher_api is mangled by the
> ESSIV handling, and throws off the parsing of "authenc(" otherwise.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

I really like to see this type of factoring out to the crypto API;
nicely done.

Acked-by: Mike Snitzer <snitzer@redhat.com>

Herbert, please feel free to pull this, and the next 6/6 patch, into
your crypto tree for 5.4.  I see no need to complicate matters by me
having to rebase my dm-5.4 branch ontop of the crypto tree, etc.

Thanks,
Mike
