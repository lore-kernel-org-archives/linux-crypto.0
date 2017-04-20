From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/6] MODSIGN: Export module signature definitions.
Date: Thu, 20 Apr 2017 15:37:37 +0100
Message-ID: <21102.1492699057@warthog.procyon.org.uk>
References: <1492691712.3081.85.camel@linux.vnet.ibm.com> <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com> <1492546666-16615-6-git-send-email-bauerman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S946424AbdDTOhl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 10:37:41 -0400
In-Reply-To: <1492691712.3081.85.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> On Tue, 2017-04-18 at 17:17 -0300, Thiago Jung Bauermann wrote:
> > IMA will use the module_signature format for append signatures, so export
> > the relevant definitions and factor out the code which verifies that the
> > appended signature trailer is valid.
> > 
> > Also, create a CONFIG_MODULE_SIG_FORMAT option so that IMA can select it
> > and be able to use validate_module_signature without having to depend on
> > CONFIG_MODULE_SIG.
> 
> Basically we want to generalize the concept of an appended signature.
>  Referring to it as a "module signature format" seems a bit confusing.
> 
> David, would you have a problem with changing the appended string from
> "~Module signature appended~\n" to something more generic?

Conceptually, no.  Is it possible that doing so could break someone's module
that they load on multiple versions of the kernel?  Say a module that only
exports things and doesn't use anything from the core or any other module.

Also, it needs to reasonably long and distinct enough to prevent a false
positive match.

David
