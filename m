From: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: Crypto API Weirdnesses
Date: Tue, 31 Jul 2007 22:26:48 +0900
Message-ID: <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com>
References: <31e679430707301336v37bc7433jed09451ab60ad89a@mail.gmail.com>
	<alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org,
	Felipe Balbi <felipebalbi@users.sourceforge.net>
To: "Satyam Sharma" <satyam@infradead.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

> > "Failed to setup dm-crypt key mapping.
> > Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and
> > verify that /dev/hda4 contains at least 133 sectors.
> > Failed to read from key storage"
>
> Looks like a "cryptsetup" error message, not kernel's.

I can't find CONFIG_DM_CRYPT in the .config.
Maybe cryptsetup needs it.

We should improve cryptsetup error message.
