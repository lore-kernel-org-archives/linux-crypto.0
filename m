Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714C0C4646B
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A7F020665
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 22:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfFXWhr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 18:37:47 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:55905 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726413AbfFXWhr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 18:37:47 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 72975181D3402;
        Mon, 24 Jun 2019 22:37:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: rod05_7db6cd2afbd24
X-Filterd-Recvd-Size: 2664
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon, 24 Jun 2019 22:37:43 +0000 (UTC)
Message-ID: <74833f93f6082c7b44f4fa8a3093ea1a751d5539.camel@perches.com>
Subject: Re: [PATCH 0/3] Clean up crypto documentation
From:   Joe Perches <joe@perches.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Gary R Hook <ghook@amd.com>, "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Date:   Mon, 24 Jun 2019 15:37:42 -0700
In-Reply-To: <20190624143748.7fcfe623@lwn.net>
References: <156140322426.29777.8610751479936722967.stgit@taos>
         <23a5979082c89d7028409ad9ae082840411e1ca6.camel@perches.com>
         <d8b359ff-5891-7bb8-d292-9f10cca04f17@amd.com>
         <977bc7c484ef55ff78de51d7555afcc3c3350b1e.camel@perches.com>
         <20190624143748.7fcfe623@lwn.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2019-06-24 at 14:37 -0600, Jonathan Corbet wrote:
> On Mon, 24 Jun 2019 13:29:42 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > > Finally, would you prefer a v2 of the patch set? Happy to do
> > > whatever is preferred, of course.  
> > 
> > Whatever Jonathan decides is fine with me.
> > Mine was just a plea to avoid unnecessarily
> > making the source text harder to read as
> > that's what I mostly use.
> 
> Usually Herbert seems to take crypto docs, so it's not necessarily up to
> me :)
> 
> I don't see much that's objectionable here.  But...
> 
> > I don't know if this extension is valid yet, but
> > I believe just using <function_name>() is more
> > readable as text than ``<function_name>`` or
> > :c:func:`<function_name>`
> 
> It's been "valid" since I wrote it...it's just not upstream yet :)  I
> expect it to be in 5.3, though.  So the best way to refer to a kernel
> function, going forward, is just function() with no markup needed.

When that's actually "valid" I suggest doing:

$ git ls-files -- 'Documentation/*.rst' | \
 xargs perl -pi -e 's/:c:func:`(\w+)(?:\(\))?`/\1()/g; s/``(\w+)\(\)``/\1()/g'

so function designations in Documentation are simpler to read.

Right now that's:

$ git diff --shortstat Documentation/
 125 files changed, 1680 insertions(+), 1680 deletions(-)


