Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1221BC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 10:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379442AbiEMKfZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 06:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359854AbiEMKfZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 06:35:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20BD61E0588
        for <linux-crypto@vger.kernel.org>; Fri, 13 May 2022 03:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652438122;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YiscHCJHMgi1oHGKt46oSAX7BJQ7MgtDGJai8XhZKQM=;
        b=Igyw7RsNgrkpVhMCxEC7G8FsRttoJ8prG97RJpo8UQABRq2uuP4cU9aIzYD56kQhvnSLeL
        znprV8uEDY/mVFQkL2r0VnC2DpNf9/Z081SU7EkuOrWKbTt+nFyhW/AjUAhv+JtQ7QcNhJ
        L/Pr2SYuQqSS8/xgKReobSubjl1IXhk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-_1tPb89cP_ucF1NJo3oLuQ-1; Fri, 13 May 2022 06:35:19 -0400
X-MC-Unique: _1tPb89cP_ucF1NJo3oLuQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93EB0294EDE5;
        Fri, 13 May 2022 10:35:18 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74DAA40D2820;
        Fri, 13 May 2022 10:35:16 +0000 (UTC)
Date:   Fri, 13 May 2022 11:35:14 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        jasowang@redhat.com, cohuck@redhat.com
Subject: Re: [PATCH v5 8/9] tests/crypto: Add test suite for RSA keys
Message-ID: <Yn40YuXEpJZ2lfCt@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220428135943.178254-1-pizhenwei@bytedance.com>
 <20220428135943.178254-9-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220428135943.178254-9-pizhenwei@bytedance.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 28, 2022 at 09:59:42PM +0800, zhenwei pi wrote:
> From: Lei He <helei.sig11@bytedance.com>
> 
> As Daniel suggested, Add tests suite for rsakey, as a way to prove
> that we can handle DER errors correctly.
> 
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> ---
>  tests/unit/test-crypto-akcipher.c | 285 +++++++++++++++++++++++++++++-
>  1 file changed, 282 insertions(+), 3 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

