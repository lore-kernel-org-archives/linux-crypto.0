From: Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 14:34:15 -0400 (EDT)
Message-ID: <620451703.157241281465255300.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <15765372.157161281465237985.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org, Linda Wang <lwang@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Neil Horman <nhorman@redhat.com>
To: Loc Ho <lho@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:52887 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756272Ab0HJSex (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 14:34:53 -0400
In-Reply-To: <15765372.157161281465237985.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,
----- "Loc Ho" <lho@apm.com> wrote:
> I had read or glance over the patch from "
> http://people.redhat.com/mitr/cryptodev-ncr/0002". We have post a
> version of the CryptoDev over a year ago. Unfortunately, we did not
> got a chance to pick up again. In that process, Herbert Xu provides a
> number of comments. You can search the mailing list for that. Here are
> my comment based on experience with hardware crypto:
Thanks for the comments.

> 1. This CrytoDev (user space) interface needs to support multiple
> operations at once

I think this would be naturally solved by providing the async interface.

> Item #2. Asnc - You can argue that you can open multiple /dev/crypto
> session and submit them. But this does not work for the same session
> and for HW base crypto. Having an async interface has the benefit to
> the user space application developer as they can use the same async
> programming interface as with other I/O operations.

Right, that would make sense - but it can be added later (by providing an "async op" operation, poll() handler, and "get next result" operation).  I'd like to get the existing functionality acceptable first.

> Item #3. Large file support - Most hardware algorithms can't support
> this as the operation cannot be continue. Not sure how to handle
> this.
The proposed interface does not have any inherent input/output size limits.

> Item #4. Right now you are pining the entire buffer. For small buffer,
> this may not make sense. We have not got a chance to see if what is
> the limit for this.
Good point; this kind of performance optimization can be added later as well, noted for future work.

> Item #5. Herbert Xu mentioned that we should avoid having a lot of
> small kmalloc when possible.
Looking at the session code, which is most critical, I see a few opportunities to improve this; noted.

> Item #6. You should give OpenSSL a patach and see how it works out.
> Although, OpenSSL does not take advantage of batch submission. Again,
> to really take advantage of the HW, you really need to support batch
> operation.
OpenSSL support is planned, but not ready yet.

Thanks again,
    Mirek
