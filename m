From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Date: Sat, 23 Jun 2007 01:06:58 +0530
Message-ID: <a781481a0706221236t3b399afdkf2e07cb109fba226@mail.gmail.com>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
	 <1182536729847-git-send-email-arw@arw.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	"Johannes Schlumberger" <spjsschl@stud.informatik.uni-erlangen.de>,
	linux-crypto@vger.kernel.org
To: "Alexander Wuerstlein" <arw@arw.name>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:3273 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXFVThA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 15:37:00 -0400
Received: by nz-out-0506.google.com with SMTP id n1so1036677nzf
        for <linux-crypto@vger.kernel.org>; Fri, 22 Jun 2007 12:36:58 -0700 (PDT)
In-Reply-To: <1182536729847-git-send-email-arw@arw.name>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Alexander, Johannes,

[ Added linux-crypto to Cc: ]

Wow, this is _one_ *intrusive* patchset indeed :-)

But first: Have you checked the digsig project? It's been doing
(for some time) what your current patchset proposes -- and
it uses public key cryptosystems for the key management,
which is decidedly better than using secret-keyed hashes
(HMAC, XCBC). Also, digsig aims to protect executable
binaries in general, and not just suid / sgid ones.

Second: Can we have some discussion on the security model /
threat model / trust model / cryptographic key management
scheme of your signing mechanism? [I had read through the
[0/4] mail you had sent yesterday, but found no relevant
discussion on these aspects there.]

>From the patchset, it appears you use a *common* secret key
for _all_ signed binaries, and it is set at kernel build-time itself:

On 6/22/07, Alexander Wuerstlein <arw@arw.name> wrote:
> sns_secret_key.dat contains the 'secret key' which is used for HMAC.

Where:

> --- /dev/null
> +++ b/security/sns_secret_key.dat
> +#define SNS_SECRET_KEY_SIZE 8
> +static char sns_secret_key[SNS_SECRET_KEY_SIZE] =
> +       {
> +               'd', 'e', 'a', 'd', 'b', 'e', 'e', 'f'
> +       };

[ Ok, I won't nitpick as to why does this file look like a header,
is #include-d in the C source as a header, but still has a .dat
extension :-) ]

Anyway, this is *totally* insecure and broken. Do you realize anybody
who lays hands on the kernel image can now _trivially_ extract the
should-have-been-a-secret key from it and use it to sign his own
binaries?

Satyam
