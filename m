From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Part2 PATCH v4.1 07/29] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Wed, 4 Oct 2017 07:22:45 -0700
Message-ID: <20171004142245.GA31796@infradead.org>
References: <20170919204627.3875-8-brijesh.singh@amd.co>
 <20171002204831.5947-1-brijesh.singh@amd.com>
 <nycvar.YSQ.7.76.1710041221390.19122@wniryva>
 <20171004092152.4lmjlsqrg25dgaxu@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: P J P <ppandit@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171004092152.4lmjlsqrg25dgaxu@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 04, 2017 at 11:21:53AM +0200, Borislav Petkov wrote:
> On Wed, Oct 04, 2017 at 12:26:11PM +0530, P J P wrote:
> > Each return above needs to be on its own line.
> 
> ... because?

It's actually readable by humanѕ that way.
