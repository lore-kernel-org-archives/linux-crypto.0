From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 15:44:37 -0400 (EDT)
Message-ID: <102267248.164891281469477439.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <897762024.164521281469254847.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46466 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751662Ab0HJTov (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 15:44:51 -0400
In-Reply-To: <897762024.164521281469254847.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- "Neil Horman" <nhorman@redhat.com> wrote:
> On Tue, Aug 10, 2010 at 03:10:12PM -0400, Steve Grubb wrote:
> > > Can you ennumerate here what FIPS and Common Criteria mandate be presented
> > > in the audit logs?
> > 
> > Who did what to whom at what time and what was the outcome. In the case of 
> > configuration changes we need the new and old values. However, we need extra 
> > information to make the selective audit work right.
> > 
> Somehow I doubt that FIPS mandates that audit messages include "who did what to
> whoom and what the result was" :).
Actually, that's about right for CC :)

> The TSF shall record within each audit record at least the following
> information:
> a) Date and time of the event, type of event, subject identity (if
> applicable), and the outcome (success or failure) of the event;

and, for specific operations, e.g.:
> Minimal level: Success and failure, and the type of cryptographic operation
> Basic level: Any applicable cryptographic mode(s) of operation, subject
> attributes and object attributes

Now what exactly is "subject/object identity" and "subject/object attributes" is the important question that's defined elsewhere, and I don't know enough about these aspects.
    Mirek
