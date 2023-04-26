Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27AAC7EE22
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Apr 2023 00:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbjDZA2k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Apr 2023 20:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbjDZA2j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2023 20:28:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6030B230;
        Tue, 25 Apr 2023 17:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EDBB62E30;
        Wed, 26 Apr 2023 00:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F893C433EF;
        Wed, 26 Apr 2023 00:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682468917;
        bh=iMl460FsgYxZKT/bQSFPVazG4qV4WaEXmxAruggaakM=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=d8vDDZ0ajEMjXZMUFXVAYmyz4oFcDQJUqol7jKydYsCl2JBZLozmT9N6HldYyGlIz
         u822996qteuHXf1cc1aTmhqrESTwpEbKZdbq28VHp58jEV8CoepVHHE6rfM3tf2jCv
         RiMgCFRMyUEuSvdl4qn20Yc7UKZKI9hPm5+3Dy/oHBMlLarVuSL8akAFRVIWJQfRVN
         aE4bW2Z+I8f56WEvbummC7E3BQV5NTqaAF/vL2S5jkMYrLJrCyeVSGvJdaKR9VKJ9i
         n9eNFZma0kTGD5/39ZobrfqGiXl+C3UmFnNTypskWeJ7xW+VAf96J2D7mKT50N1rNm
         4Sfv/WPsnWctw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 26 Apr 2023 03:28:30 +0300
Message-Id: <CS69GBAMXJ1X.1T8NO0CZUBXLG@suppilovahvero>
Cc:     <linux-kernel@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        "Roberto Sassu" <roberto.sassu@huawei.com>
Subject: Re: [RFC][PATCH 3/6] verification: Introduce verify_umd_signature()
 and verify_umd_message_sig()
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Roberto Sassu" <roberto.sassu@huaweicloud.com>,
        <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <rostedt@goodmis.org>,
        <mhiramat@kernel.org>, <mykolal@fb.com>, <shuah@kernel.org>
X-Mailer: aerc 0.14.0
References: <20230425173557.724688-1-roberto.sassu@huaweicloud.com>
 <20230425173557.724688-4-roberto.sassu@huaweicloud.com>
In-Reply-To: <20230425173557.724688-4-roberto.sassu@huaweicloud.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue Apr 25, 2023 at 8:35 PM EEST, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Introduce verify_umd_signature() and verify_umd_message_sig(), to verify
> UMD-parsed signatures from detached data. It aims to be used by kernel
> subsystems wishing to verify the authenticity of system data, with
> system-defined keyrings as trust anchor.

UMD is not generic knowledge. It is a term coined up in this patch set
so please open code it to each patch.

One discussion points should be what these handlers should be called.
Right now the patch set is misleads the reader to think as this was
some kind of "official" term and set to stone.

BR, Jarkko
