From: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
Subject: Re: [PATCH] crypto: add test vectors for skein256/512/1024
Date: Wed, 5 Nov 2008 22:27:48 +0100
Message-ID: <20081105212748.GA4990@Chamillionaire.breakpoint.cc>
References: <20081102161506.GA21940@havoc.gtf.org> <20081102201518.GA23620@Chamillionaire.breakpoint.cc> <490E5788.4080300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753334AbYKEV2U@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <490E5788.4080300@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Jeff Garzik | 2008-11-02 20:44:40 [-0500]:

> Sebastian Andrzej Siewior wrote:
>> I grabed them from http://www.schneier.com/skein.html. The last test 
>> vector
>> (3) in every category is currently deactivated because it failed always.
>> It is unlikely that I made a type because I copy+pasted the tables + vim
>> magiced them. So maybe code may missbehave on requests lengths which are
>> not a multiple of 4 or the vectors can not be used due to some other
>> limitations that I've overseen.

Okay, that was a false positive :)
The "untouched" reference implementation outputs the same hash. The
additional information (tree, ...) is part of the third argument in
Skein_XXX_InitExt() which isn't used. So we can safely drop the third
test vector.

>
> 	Jeff

Sebastian
