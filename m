From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Tue, 17 Apr 2007 08:40:13 -0700
Message-ID: <adairbv57s2.fsf@cisco.com>
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	<E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	<38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	helge.hafting@aitel.hist.no, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: "Francis Moreau" <francis.moro@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030657AbXDQPkT@vger.kernel.org>
In-Reply-To: <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com> (Francis Moreau's message of "Tue, 17 Apr 2007 16:41:00 +0200")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

 > Again, my code is faster only because I skip the key loading in 
 > "cia_encrypt" method. Actually the gain is bigger in decryption mode 
 > than in encryption one because I also generate the decryption key for 
 > each block.

I wonder if there's some way you can cache the last caller and reload
the key lazily (only when it changes).  Of course without your code
it's hard to say...
