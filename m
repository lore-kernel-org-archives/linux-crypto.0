Return-Path: <SRS0=RIhc=ZC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74125C43331
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 00:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F2CC2085B
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 00:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfKJADc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 19:03:32 -0500
Received: from twin.jikos.cz ([91.219.245.39]:53096 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfKJADb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 19:03:31 -0500
X-Greylist: delayed 3411 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Nov 2019 19:03:30 EST
Received: from twin.jikos.cz (dave@[127.0.0.1])
        by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id xA9N57HH013161
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Sun, 10 Nov 2019 00:05:08 +0100
Received: (from dave@localhost)
        by twin.jikos.cz (8.13.6/8.13.6/Submit) id xA9N57eY013160;
        Sun, 10 Nov 2019 00:05:07 +0100
Date:   Sun, 10 Nov 2019 00:05:07 +0100
From:   David Sterba <dave@jikos.cz>
To:     David Sterba <dsterba@suse.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/7] BLAKE2b cleanups
Message-ID: <20191109230507.GC9344@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org
References: <cover.1573047517.git.dsterba@suse.com>
 <20191108021329.GA1140@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108021329.GA1140@sol.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 07, 2019 at 06:13:29PM -0800, Eric Biggers wrote:
> On Wed, Nov 06, 2019 at 02:48:24PM +0100, David Sterba wrote:
> > the patchset implements cleanups suggested by Eric in
> > https://lore.kernel.org/linux-crypto/20191025051550.GA103313@sol.localdomain/
> > 
> > The diff is the same, split into pieces with some additional comments
> > where it would help understand the simplifications. This is based on v7
> > of the BLAKE2b patchset.
> 
> Actually the diff isn't quite the same.  Your version looks fine though, except
> that I think digest_setkey() should be renamed to blake2b_setkey().  Otherwise
> it's inconsistent, since all the other digest_*() functions were renamed.

Right, digest_* was a leftover from a working version. I'll send V2.
Thanks for the review.
