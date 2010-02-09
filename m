From: Nix <nix@esperi.org.uk>
Subject: Re: LZO irreversible output?
Date: Tue, 09 Feb 2010 17:32:27 +0000
Message-ID: <874olq1fis.fsf@spindle.srvr.nix>
References: <4B69ECE5.5060505@crca.org.au> <201002032354.11284.rjw@sisk.pl>
	<4B6A4F07.3090509@crca.org.au> <hkneh9$djl$1@ger.gmane.org>
	<4B6FCC47.2030705@crca.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tuxonice-devel@lists.tuxonice.net, Bill Davidsen <davidsen@tmr.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Nigel Cunningham <ncunningham@crca.org.au>
Return-path: <tuxonice-devel-bounces@lists.tuxonice.net>
In-Reply-To: <4B6FCC47.2030705@crca.org.au> (Nigel Cunningham's message of
	"Mon, 08 Feb 2010 19:33:11 +1100")
List-Unsubscribe: <http://lists.tuxonice.net/options/tuxonice-devel>,
	<mailto:tuxonice-devel-request@lists.tuxonice.net?subject=unsubscribe>
List-Archive: <http://lists.tuxonice.net/pipermail/tuxonice-devel>
List-Post: <mailto:tuxonice-devel@lists.tuxonice.net>
List-Help: <mailto:tuxonice-devel-request@lists.tuxonice.net?subject=help>
List-Subscribe: <http://lists.tuxonice.net/listinfo/tuxonice-devel>,
	<mailto:tuxonice-devel-request@lists.tuxonice.net?subject=subscribe>
Sender: tuxonice-devel-bounces@lists.tuxonice.net
Errors-To: tuxonice-devel-bounces@lists.tuxonice.net
List-Id: linux-crypto.vger.kernel.org

On 8 Feb 2010, Nigel Cunningham verbalised:
> That said, the actual code that TuxOnIce uses does already initialise
> the variable to PAGE_SIZE, so it seems that I might just have to run
> with the checking code enabled (with this fix) for a while, until the
> issue is found.

If you push the fix somewhere I'll run with it as well and see if I can
make this problem happen again. (So far I've only seen it with both
compression and max_workers > 1, but I haven't done a systematic check
for this so it could be an illusion.)
