Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8502EC4320E
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Aug 2021 17:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F96B613CF
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Aug 2021 17:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhHWRi1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Aug 2021 13:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhHWRi0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Aug 2021 13:38:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46D9D61374;
        Mon, 23 Aug 2021 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629740263;
        bh=hd1DiAtq6M95xP7Zk6zWPriFPvaDGMunfRc3tlUDq04=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HYtSMTTtvMzjR5lgitFZf/EHMqu5HLAWiPO+m9DAmIV1j8gJ4SycFEIyo0YWY+OHz
         mmZ03fh60fTzDihIlR6rLlNQGJlk4R6uLNOx7awwucO7kUYLZCQCSxmU/6WsoLrH8b
         ypSahM5Am0WpT4O11Lcnk+10OS3c9hLNPVNezBugOnSgqQILKaoBC+NQdiT/xGa1Xw
         Z+ypnZRkinv4o3Dtj6ErHrQcfe8kWvmQi15bYo3+YapWDwv2B1flf1XJTKvF9r0Lri
         PXHEqVCAfw8rjkpUA6TkN3eL1FIOYLE6XmvMD17MqQ8f4Q6sRoyllJcjYKc8l70KqN
         0ftw73DccdQtQ==
Message-ID: <64138a8af4658e526ad50988baf785b604e8c4de.camel@kernel.org>
Subject: Re: [PATCH v4 00/12] Enroll kernel keys thru MOK
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Snowberg <eric.snowberg@oracle.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>
Cc:     keyrings@vger.kernel.org,
        linux-integrity <linux-integrity@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>, keescook@chromium.org,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        scott.branden@broadcom.com, weiyongjun1@huawei.com,
        nayna@linux.ibm.com, ebiggers@google.com, ardb@kernel.org,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        lszubowi@redhat.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        pjones@redhat.com,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Patrick Uiterwijk <patrick@puiterwijk.org>
Date:   Mon, 23 Aug 2021 20:37:41 +0300
In-Reply-To: <91B1FE51-C6FC-4ADF-B05A-B1E59E20132E@oracle.com>
References: <20210819002109.534600-1-eric.snowberg@oracle.com>
         <fcb30226f378ef12cd8bd15938f0af0e1a3977a2.camel@kernel.org>
         <f76fcf41728fbdd65f2b3464df0821f248b2cba0.camel@linux.ibm.com>
         <91B1FE51-C6FC-4ADF-B05A-B1E59E20132E@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-08-19 at 09:23 -0600, Eric Snowberg wrote:
> > On Aug 19, 2021, at 7:10 AM, Mimi Zohar <zohar@linux.ibm.com> wrote:
> >=20
> > On Thu, 2021-08-19 at 14:38 +0300, Jarkko Sakkinen wrote:
> > > On Wed, 2021-08-18 at 20:20 -0400, Eric Snowberg wrote:
> > > > Downstream Linux distros try to have a single signed kernel for eac=
h
> > > > architecture.  Each end-user may use this kernel in entirely differ=
ent
> > > > ways.  Some downstream kernels have chosen to always trust platform=
 keys
> > > > within the Linux trust boundary for kernel module signing.  These
> > > > kernels have no way of using digital signature base IMA appraisal.
> > > >=20
> > > > This series introduces a new Linux kernel keyring containing the Ma=
chine
> > > > Owner Keys (MOK) called .mok. It also adds a new MOK variable to sh=
im.
> > >=20
> > > I would name it as ".machine" because it is more "re-usable" name, e.=
g.
> > > could be used for similar things as MOK. ".mok" is a bad name because
> > > it binds directly to a single piece of user space software.
> >=20
> > Nayna previously said,
> >   "I believe the underlying source from where CA keys are loaded might =
vary=20
> >   based on the architecture (".mok" is UEFI specific.). The key part is=
=20
> >   that this new keyring should contain only CA keys which can be later=
=20
> >   used to vouch for user keys loaded onto IMA or secondary keyring at=
=20
> >   runtime. It would be good to have a "ca" in the name, like .xxxx-ca,=
=20
> >   where xxxx can be machine, owner, or system. I prefer .system-ca."
> >=20
> > The CA keys on the MOK db is simply the first root of trust being
> > defined, but other roots of trust are sure to follow.  For this reason,
> > I agree naming the new keyring "mok" should be avoided.
>=20
> As I said previously, I=E2=80=99m open to renaming, I just would like to =
have an=20
> agreement on the new name before changing everything.  The current propos=
ed=20
> names I have heard are =E2=80=9C.machine" and ".system-ca".  Is there a p=
reference=20
> the maintainers feel is appropriate?  If so, please let me know and I=E2=
=80=99ll=20
> rename it. Thanks.


Just ".system" would be good. It's informative enough.


/Jarkko
