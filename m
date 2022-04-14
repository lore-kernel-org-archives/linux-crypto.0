Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2486C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Apr 2022 15:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348356AbiDNP75 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Apr 2022 11:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346573AbiDNPO4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Apr 2022 11:14:56 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77452C4E12
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 07:54:10 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u15so10494072ejf.11
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 07:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A8enJE2kgTvLDP4Z3zj1q1oPMHVhORo++ZPeVPtFzPE=;
        b=SCbhXDMRgTrJEAge2x1K4iyiidPcE9AZMD0hIPSONtHNqhtu4H9aJGRk3CQpBOj12t
         ClrvmwaM2fa1l279n8D6Vo6e92qire86sLIy8MnJH/eqSamy646ufJG7vn+LNWrqoZlI
         Ezp49Sd7cbQMxPjOE+XteJ2m0Ha/nokccyX6MmPcGti/ODqglhzIx6vepUsQtPrc7UxK
         ubyI4yhahOA5LxTKv5xQqDZ2vcFRuhw4d5PqSyDlykTbl4Nd7eEbl88bQtHlBduo+W13
         q3yZIC99a22O1zgeaOvwXxwe8kyBmvAFSCiL74IPIcWODhhl+a+uMfLqKsX9h7MxgB+E
         D6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A8enJE2kgTvLDP4Z3zj1q1oPMHVhORo++ZPeVPtFzPE=;
        b=skYQDByUq9y8SRk5Kw1mocDrt81pqNEcBcVlKwzarqVsNm2uB71loW4fK3UukPHF7w
         wlH9bRRJRh5oJ1zKcUM4akNHPdHRUTecciRnekH5EelY37O+HZY46p1YwfOxOpB+ELDL
         AR/TwT7J9pg0ZymGzzdMps+aZVrkHeQ5fDHHcARmSqpiGNjIyxbt0J0BHY0YpfdDqF87
         L+U83fyY6fQfSt2yG49N2DfwfoEXwGmIg/B3ymupqgU5/NcuYDr8d+Dsr+x3QuHXQBrM
         LJ7iF7IPuE0GXQoVSnfQ7JU8REQePsK2ZHumWWtUsLh817s/u+9pZQ/Mar3HBBuGXanI
         JuQw==
X-Gm-Message-State: AOAM531DaIZVp7vnVVe4fDwY6pBwlhEzDHeopuDZo1sMimf9M2VN/ii+
        kKg3u73p2Cwu1MFQVql8Q1hPsj2VDp++maW6f5pNceIQ
X-Google-Smtp-Source: ABdhPJxq11kRiXy7GzI9/4fKx6zag5b2xUZMCAmKeiQsND62BLerg+ykIqiqyyu/0hgqwygBBPorh0H4oDG38hq1pjA=
X-Received: by 2002:a17:907:7b9d:b0:6df:fb8f:fe82 with SMTP id
 ne29-20020a1709077b9d00b006dffb8ffe82mr2588856ejc.652.1649948048988; Thu, 14
 Apr 2022 07:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220111124104.2379295-1-festevam@gmail.com> <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
 <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com> <CAOMZO5AAYHRUUy872KgO9PuYwHbnOTQ80TSCx1jvmtgH+HzDGg@mail.gmail.com>
 <AM9PR04MB821114617421652847FFBBF3E8179@AM9PR04MB8211.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB821114617421652847FFBBF3E8179@AM9PR04MB8211.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 14 Apr 2022 11:53:57 -0300
Message-ID: <CAOMZO5AUJyrhzM4TJkxWqawZ41d0aLbDa1912F1-71tcpWoJUQ@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH] crypto: caam - enable prediction resistance conditionally
To:     Varun Sethi <V.Sethi@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrei Botila <andrei.botila@nxp.com>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        "fredrik.yhlen@endian.se" <fredrik.yhlen@endian.se>,
        "hs@denx.de" <hs@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Varun,

On Tue, Mar 22, 2022 at 10:56 AM Varun Sethi <V.Sethi@nxp.com> wrote:

> [Varun] Yes, we have made progress on the fix. Currently we are testing the fix and should be able to post the patch upstream pretty soon.

Any progress on the fix?

Thanks
