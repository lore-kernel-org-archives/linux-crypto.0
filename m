Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C727EE49A5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Aug 2023 02:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbjHWCS2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Aug 2023 22:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjHWCS1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2023 22:18:27 -0400
X-Greylist: delayed 917 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 19:18:25 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8917185
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2023 19:18:25 -0700 (PDT)
X-AuditID: cb7c291e-06dff70000002aeb-c7-64e553f378c9
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id B7.72.10987.3F355E46; Wed, 23 Aug 2023 05:33:55 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=UVCydWsfwbTJXCCdm+C9DWKtARRK342rDtYW/rR+DwzXmguYJcRkaFMlAIhqNtYBe
          1mwfWC+tKOQp62fYFO7s+ym1WrEeaEf9E9VsLkiZ4T6P6IFzuHL0zi0JvnOy3itI1
          vjcebOwWf67Wy0ReMrqnpBPoZzO5TA6YLATRvy6GM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=njPMSTpHFAbhDUqTBLa0Z7PIYdBhoCNZXmun5ajzsnlxRaq0er/4xJETrqy/VI1mY
          cP1FlIGz0ylLQD89HDHO0MfMCEs3EWnj/FUD9PZaANXGIjz9xDwD/PvPCxkE+hJRN
          SVM+bnPe9rHmEozDJlY0NSvzqx9vtpmVdOtFjbq8o=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:30:59 +0500
Message-ID: <B7.72.10987.3F355E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-crypto@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:13 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVyyUKGW/dz8NMUg2dzpC3u3/vJ5MDo8XmT
        XABjFJdNSmpOZllqkb5dAlfGknUXWAp2M1e09S9iaWB8zNTFyMEhIWAicW9BVRcjF4eQwB4m
        ie03bzCCOCwCq5kldhx7wg7hPGSWWH3tFzNEWTOjRM+eNWxdjJwcvALWErvPt7KA2MwCehI3
        pk6BigtKnJz5BCquLbFs4WtmkHXMAmoSX7tKQMLCAmISn6YtYwcJiwgoSMz7qgMSZhPQl1jx
        tZkRxGYRUJW4cn0t2BQhASmJjVfWs01g5J+FZNksJMtmIVk2C2HZAkaWVYwSxZW5icBASzbR
        S87PLU4sKdbLSy3RK8jexAgMwtM1mnI7GJdeSjzEKMDBqMTD+3PdkxQh1sQyoK5DjBIczEoi
        vNLfH6YI8aYkVlalFuXHF5XmpBYfYpTmYFES57UVepYsJJCeWJKanZpakFoEk2Xi4JRqYJyc
        EyVZ8u7b3DkHI9/yBh94tSNvuZXY5Jo9WTMClxZ4P+fR8XsXtH3CgUc/m2MbVvvnLNR8vyCm
        yZj/s2Xrrtxabfnb25VFe/5/bmDM3eq1YNNfLoHfed90a93qfhycyRwZwtQ9PWAPR1/bOvUA
        Q7c97GtfLdOfJJn292vCFd5dVUdcZOoSeJVYijMSDbWYi4oTAb9TIKg+AgAA
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

