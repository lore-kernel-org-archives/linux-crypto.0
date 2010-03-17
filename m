From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: cryptodev support
Date: Wed, 17 Mar 2010 14:43:27 +0100
Message-ID: <4BA0DC7F.3010407@gnutls.org>
References: <4BA0CFFD.7080705@gnutls.org> <1268831320.2901.21.camel@ec>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Emanuele Cesena <emanuele.cesena@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:46058 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0CQNsd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Mar 2010 09:48:33 -0400
Received: by ewy1 with SMTP id 1so409791ewy.38
        for <linux-crypto@vger.kernel.org>; Wed, 17 Mar 2010 06:48:32 -0700 (PDT)
In-Reply-To: <1268831320.2901.21.camel@ec>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Emanuele Cesena wrote:
> On Wed, 2010-03-17 at 13:50 +0100, Nikos Mavrogiannopoulos wrote:
>> Hello,
>>  I needed to access crypto hardware modules from userspace and I made
>> that by adding cryptodev support on top of linux-crypto. It is a
>> separate module available at:
>> http://repo.or.cz/w/cryptodev-linux.git
>>
> I'm also interested in the userspace module (we are working on a patch
> for opencryptoki), but this version looks quite different from the ideas
> "recently" discussed in this mailing list and, probably even more
> important, from the idea for future development (i.e. moving to a
> socket-like interface).

I'm not aware of the discussion in the ml. I don't argue that this is
the only way to expose the internal API to userspace. It is one way that
few other OS's support as well. For this reason it is the best from the
user-space developer point of view to have a single API across many OS'.

regards,
Nikos
