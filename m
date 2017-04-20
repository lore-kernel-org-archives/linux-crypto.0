From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] MODSIGN: Export module signature definitions.
Date: Thu, 20 Apr 2017 18:07:15 -0300
Message-ID: <1544111.Uq9hhXcF4r@morokweng>
References: <1492691712.3081.85.camel@linux.vnet.ibm.com> <1492546666-16615-6-git-send-email-bauerman@linux.vnet.ibm.com> <21102.1492699057@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <21102.1492699057@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 20. April 2017, 15:37:37 BRT schrieb David Howells:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Tue, 2017-04-18 at 17:17 -0300, Thiago Jung Bauermann wrote:
> > > IMA will use the module_signature format for append signatures, so
> > > export
> > > the relevant definitions and factor out the code which verifies that the
> > > appended signature trailer is valid.
> > > 
> > > Also, create a CONFIG_MODULE_SIG_FORMAT option so that IMA can select it
> > > and be able to use validate_module_signature without having to depend on
> > > CONFIG_MODULE_SIG.
> > 
> > Basically we want to generalize the concept of an appended signature.
> >  Referring to it as a "module signature format" seems a bit confusing.
> > 
> > David, would you have a problem with changing the appended string from
> > "~Module signature appended~\n" to something more generic?
> 
> Conceptually, no.  Is it possible that doing so could break someone's module
> that they load on multiple versions of the kernel?  Say a module that only
> exports things and doesn't use anything from the core or any other module.

I think that changing the appended string has limited value because very few 
people actually see them. It's just a marker. We could s/module_signature/
appended_signature/ in the code but keep the actual string unchanged. What do 
you think?

Alternatively, we could change the string but accept both the old and the new 
string for backwards compatibility.

-- 
Thiago Jung Bauermann
IBM Linux Technology Center

