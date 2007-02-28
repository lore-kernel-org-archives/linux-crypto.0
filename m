From: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: [PATCH 5/5] jffs2: Allow selection of compression mode via a
	sysfs attribute
Date: Wed, 28 Feb 2007 20:56:56 +0000
Message-ID: <1172696216.16062.147.camel@localhost.localdomain>
References: <1172690034.16062.144.camel@localhost.localdomain>
	<1172691583.17031.35.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-mtd <linux-mtd@lists.infradead.org>,
	David Woodhouse <dwmw2@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au
To: dedekind@infradead.org
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <1172691583.17031.35.camel@sauron>
List-Unsubscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: linux-mtd-bounces@lists.infradead.org
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2007-02-28 at 21:39 +0200, Artem Bityutskiy wrote:
> On Wed, 2007-02-28 at 19:13 +0000, Richard Purdie wrote:
> > +/* gives us jffs2_subsys */
> > +static decl_subsys(jffs2, NULL, NULL);
> 
> There is actually a file-system subsys - look up for fs_subsys. It is
> declared at fs/namespace.c.

Further down the patch you'll see:

+	kset_set_kset_s(&jffs2_subsys, fs_subsys);

There was a reason for doing that instead using fs_subsys in the above
although I can't remember why offhand. I did try it and it didn't work
as expected...

Regards,

Richard


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
