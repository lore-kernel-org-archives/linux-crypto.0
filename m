Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7B4C47089
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Dec 2022 17:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiLGRw1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLGRwZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2022 12:52:25 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC746C712;
        Wed,  7 Dec 2022 09:52:24 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D3AA220099;
        Wed,  7 Dec 2022 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670435542;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LcfuBKfj+SmUIFdtyNgyT98NAvKhCAYytID8/EBoQ/U=;
        b=KPHrmKNlSvwAMKEy5/oCDTJDDj9tnp2KM4WxHfv3K2DZK79bT/YhSYbzfjWLoZhHwEc+0+
        +2/UIxhXFOKbgcAQmcmjox35FERvw2qP1T0UTPJyGTny0+7VQn3cmVjaIGlSxWaFfTjeqd
        fW4ApU91TBSMaIxiwQjtpOOJVtbw9F8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670435542;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LcfuBKfj+SmUIFdtyNgyT98NAvKhCAYytID8/EBoQ/U=;
        b=3/auTOd5wlaYfGrTs/x54fkoMS4u1h3rIMygpHuiZa0c/LZCOOue8glGAtJea+w2S2+it9
        Zq7p5PWwfkza/oDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 9F8E0136B4;
        Wed,  7 Dec 2022 17:52:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id ebiZI9XSkGOMewAAGKfGzw
        (envelope-from <pvorel@suse.cz>); Wed, 07 Dec 2022 17:52:21 +0000
Date:   Wed, 7 Dec 2022 18:52:19 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Snowberg <eric.snowberg@oracle.com>
Cc:     jarkko@kernel.org, zohar@linux.ibm.com, dhowells@redhat.com,
        dwmw2@infradead.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        noodles@fb.com, tiwai@suse.de, bp@suse.de,
        kanth.ghatraju@oracle.com, konrad.wilk@oracle.com,
        erpalmer@linux.vnet.ibm.com, coxu@redhat.com,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 01/10] KEYS: Create static version of
 public_key_verify_signature
Message-ID: <Y5DS00rCs9+BOQSd@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20221207171238.2945307-1-eric.snowberg@oracle.com>
 <20221207171238.2945307-2-eric.snowberg@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207171238.2945307-2-eric.snowberg@oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

Reviewed-by: Petr Vorel <pvorel@suse.cz>

Kind regards,
Petr
