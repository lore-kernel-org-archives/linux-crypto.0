Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AC2C77B75
	for <linux-crypto@archiver.kernel.org>; Wed, 17 May 2023 02:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbjEQCx2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 May 2023 22:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjEQCx0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2023 22:53:26 -0400
Received: from a27-52.smtp-out.us-west-2.amazonses.com (a27-52.smtp-out.us-west-2.amazonses.com [54.240.27.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643094493
        for <linux-crypto@vger.kernel.org>; Tue, 16 May 2023 19:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684291599;
        h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding;
        bh=KQmit5OcpOxpqlAG2WNT/FBrH9mqQ2rnKfBqNv+af6o=;
        b=eFZ25YFhluKlo44NiPU38p0wv+C3FA3LRpGXKYCj/SecwKEYys9EP568OoXONrJ2
        4hqgX3Zh/wRRBwrIbDlhhQ+Jmsz5fs6XeiizE564GGnDGIea+rnIstcr+S0v75OP0t+
        U9QruQC7N1azgTDrLnvoguexkLpDm20UY1sZAWhGoWLIfWWLbPaSj4paBe6tNokoV+x
        X6pkgKiW9wwxOJe5CLFmyodL7sZ6VKp1rspoHI0w2Zx3kK34cpzftKQ6N3dbSUtS/du
        oko4jBQv/5qL42ZPO31461TtdRHKZxPw8SXWrcQq5Z6FzKuVgFi02hPL1pQT3BHmZkU
        uLAOmHbMjA==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684291599;
        h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=KQmit5OcpOxpqlAG2WNT/FBrH9mqQ2rnKfBqNv+af6o=;
        b=VECbSMQEsdcKEVV5U/aNeTaehZqFXGP17fiictEbFu96F/C20w302G31gZ7q8qNO
        +r4G8noPf3JofkgR55seDkKhveinmOO+t4tT6u70DLumUymchi5QL7ifCNdO5j6KVuU
        5fPQyEl3hnSFdAX6MZWUgcOBR9yHCEyj2qw9F6T0=
Date:   Wed, 17 May 2023 02:46:39 +0000
Message-ID: <01010188279a3c77-331a93b1-4bef-491f-b772-564ec329b92c-000000@us-west-2.amazonses.com>
To:     wedsonaf@gmail.com
Cc:     tomo@exabit.dev, rust-for-linux@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        fujita.tomonori@gmail.com
Subject: Re: [PATCH 2/2] rust: add socket support
From:   FUJITA Tomonori <tomo@exabit.dev>
In-Reply-To: <CANeycqohNOf38MDw4mybzBib2Apu=7b_6qn_1oykm70zMVvKrw@mail.gmail.com>
References: <20230515043353.2324288-1-tomo@exabit.dev>
        <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
        <CANeycqohNOf38MDw4mybzBib2Apu=7b_6qn_1oykm70zMVvKrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.us-west-2.j0GTvY5MHQQ5Spu+i4ZGzzYI1gDE7m7iuMEacWMZbe8=:AmazonSES
X-SES-Outgoing: 2023.05.17-54.240.27.52
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Tue, 16 May 2023 14:08:47 -0300
Wedson Almeida Filho <wedsonaf@gmail.com> wrote:

> We have basic networking support in the `rust` branch. In fact, we
> also have support for async networking in there as well. For example,
> the 9p server uses it.
> 
> At the moment we're prioritizing upstreaming the pieces for which we
> have projects waiting. Do you have an _actual_ user in mind for this?

I've implemented in-kernel TLS 1.3 handshake on the top of this.

https://github.com/fujita/rust-tls

The in-kernel TLS handshake feature is controversial. Proposals were
rejected in the past. So I like to know the opinions of subsystem
maintainers early, implementing in-kernel security-relevant code in
Rust could change the situation.

The requirement for networking is simple, read/write with a vector and
setsockopt. So I submitted minimum abstractions.


> In any case, let's please start with that instead of a brand-new
> reimplementation.

Sure, if netdev maintainers could merge Rust abstractions for
networking soon, I'll rework on this. But I don't think there is much
overlap between this and rust branch. Even if we could have
abstractions specific for TCP like TcpListener and TcpStream, we still
need thin abstractions for socket because there are several use-cases
of non IP sockets, I think.

Thanks,
